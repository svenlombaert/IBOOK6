/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3 {


import be.devine.cp3.config.Config;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.service.PageService;
import be.devine.cp3.utils.memory.ClearMemory;
import be.devine.cp3.view.Page;
import be.devine.cp3.view.PageContainer;
import be.devine.cp3.view.ViewModeController;
import be.devine.cp3.view.controls.PrevNextSlideButton;
import be.devine.cp3.view.viewmodes.Thumbnail;
import be.devine.cp3.vo.PageVO;

import com.adobe.images.JPGEncoder;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.ui.Keyboard;
import flash.utils.ByteArray;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Application extends Sprite {

    private var appModel:AppModel;
    private var bgContainer:Sprite;
    private var textureAtlas:TextureAtlas;
    private var previousControl:PrevNextSlideButton;
    private var nextControl:PrevNextSlideButton;
    private var viewModeController:ViewModeController;
    private var pageContainer:PageContainer;
    private var bgLoader:Loader;
    private var backgroundImg:Image;
    private var originalBgWidth:int;
    private var originalBgHeight:int;

    private var pageService:PageService;

    private var thumbnailToLoad:uint;

    [Embed(source="/assets/images_design/spritesheet.xml", mimeType="application/octet-stream")]
    public static const ButtonXML:Class;

    [Embed(source="/assets/images_design/spritesheet.png")]
    public static const ButtonTexture:Class;

    [Embed(source="/assets/font/HelveticaNeueLTStd-Roman.otf", embedAsCFF="false", fontFamily="HelveticaNeue")]
    private static const HelveticaNeue:Class;

    [Embed(source="/assets/font/HelveticaNeueLTStd-Bd.otf", embedAsCFF="false", fontFamily="HelveticaNeueBold")]
    private static const HelveticaNeueBold:Class;

    public function Application() {

        appModel = AppModel.getInstance();
        appModel.timelineView = true;
        appModel.selectedColorIndex = 0xdd8716;
        appModel.thumbScrollbarPosition = 0;
        this.appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);

        pageService = new PageService();
        pageService.load();
        pageService.addEventListener(flash.events.Event.COMPLETE, pageServiceCompleteHandler);

        if(Config.GENERATE_THUMBNAILS == false){

            var texture:Texture = Texture.fromBitmap(new ButtonTexture());
            var xml:XML = XML(new ButtonXML());
            textureAtlas = new TextureAtlas(texture, xml);
            bgLoader = new Loader();
            bgLoader.load(new URLRequest("assets/images_design/bg_pattern.png"));
            bgLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, backgroundTextureLoadedHandler);

            Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDownEventHandler);
            this.addEventListener("BACKGROUNDINITIALIZING_COMPLETE", backgroundInitializingComplete);
        }
    }

    //----METHODS
    private function backgroundTextureLoadedHandler(event:flash.events.Event):void {
        var texture:Texture = Texture.fromBitmap(bgLoader.content as Bitmap);
        backgroundImg = new Image(texture);
        texture.repeat = true;
        originalBgHeight = backgroundImg.height;
        originalBgWidth = backgroundImg.width;
        addChild(backgroundImg);
        dispatchEvent(new starling.events.Event("BACKGROUNDINITIALIZING_COMPLETE"));
    }

    private function keyboardDownEventHandler(event:KeyboardEvent):void {
        //keyboard event om door de pagina's te gaan.
        Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardDownEventHandler);
        Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyboardUpEventHandler);

        switch(event.keyCode){
            case Keyboard.LEFT: appModel.gotoPreviousPage();break;
            case Keyboard.RIGHT: appModel.gotoNextPage(); break;
            case 32: if(viewModeController) appModel.openViewModes(); break;
        }
    }

    private function keyboardUpEventHandler(event:KeyboardEvent):void {
        Starling.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyboardUpEventHandler);
        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDownEventHandler);
    }

    private function backgroundInitializingComplete(event:starling.events.Event):void {

        pageContainer = new PageContainer();
        addChild(pageContainer);

        previousControl= new PrevNextSlideButton(textureAtlas, "previous");
        previousControl.addEventListener(PrevNextSlideButton.PREVNEXT_CLICKED, previousCLickedHandler);
        nextControl= new PrevNextSlideButton(textureAtlas, "next");
        nextControl.addEventListener(PrevNextSlideButton.PREVNEXT_CLICKED, nextClickedHandler);

        viewModeController = new ViewModeController(textureAtlas);

        addChild(previousControl);
        addChild(nextControl);
        addChild(viewModeController);
        display();
    }

    private function nextClickedHandler(event:starling.events.Event):void {
        appModel.gotoNextPage();
    }

    private function previousCLickedHandler(event:starling.events.Event):void {
        appModel.gotoPreviousPage();
    }

    private function resizeHandler(event:flash.events.Event):void {
        display();
    }

    private function display():void{

        var horizontalReps:Number = appModel.appwidth/originalBgWidth;
        var verticalReps:Number = appModel.appheight/originalBgHeight;
        backgroundImg.setTexCoords(1, new Point(horizontalReps, 0));
        backgroundImg.setTexCoords(2, new Point(0, verticalReps));
        backgroundImg.setTexCoords(3, new Point(horizontalReps, verticalReps));
        backgroundImg.width = originalBgWidth * horizontalReps;
        backgroundImg.height = originalBgHeight * verticalReps;

        previousControl.y = (appModel.appheight - previousControl.height) >> 1;
        previousControl.x = -previousControl.width/2;
        nextControl.x = appModel.appwidth - nextControl.width/2;
        nextControl.y = (appModel.appheight - nextControl.height) >> 1;
    }

    private function pageServiceCompleteHandler(event:flash.events.Event):void {
        this.appModel.pages = pageService.pages;
        this.appModel.selectedPageIndex = 0;

        if(Config.GENERATE_THUMBNAILS){
            thumbnailToLoad = 0;
            generateThumbnails();
        }
    }

    private function generateThumbnails(){
        var directory:File = File.desktopDirectory.resolvePath("thumbnails");
        directory.createDirectory();


        if(thumbnailToLoad < appModel.pages.length){

            trace('LOAD THUMBNAIL ', thumbnailToLoad);
            var page:Page = new Page(appModel.pages[thumbnailToLoad]);
            addChild(page);
            if(page.hasBackground){
                page.addEventListener(starling.events.Event.COMPLETE, pageLoadedHandler);
            }else{
                takeScreenshot();
            }

        }else{
            trace('-----THUMBNAILS FINISHED------');
        }

    }

    private function takeScreenshot():void{
        var support:RenderSupport = new RenderSupport();
        RenderSupport.clear(stage.color, 1.0);
        support.setOrthographicProjection(appModel.appwidth*(appModel.appwidth/Thumbnail.MAXWIDTH), appModel.appheight*(appModel.appheight/Thumbnail.MAXHEIGHT));
        stage.render(support, 1.0);
        support.finishQuadBatch();

        var result:BitmapData = new BitmapData(Thumbnail.MAXWIDTH, Thumbnail.MAXHEIGHT, true);
        Starling.context.drawToBitmapData(result);

        var jpgEncoder:JPGEncoder = new JPGEncoder(60);
        var byteArray:ByteArray = jpgEncoder.encode(result);

        var file:File = File.desktopDirectory.resolvePath("thumbnails/" + "thumbnail" + thumbnailToLoad + ".jpg");

        var wr:File = new File( file.nativePath);
        var stream:FileStream = new FileStream();
        stream.open( wr , FileMode.WRITE);
        stream.writeBytes (byteArray);
        stream.close();

        ClearMemory.clear(this);
        thumbnailToLoad += 1;
        generateThumbnails();
    }

    private function pageLoadedHandler(event:starling.events.Event):void {
        takeScreenshot();
    }
}
}
