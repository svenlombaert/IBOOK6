/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3 {


import be.devine.cp3.model.AppModel;
import be.devine.cp3.view.PageContainer;
import be.devine.cp3.view.ViewModeController;
import be.devine.cp3.view.controls.PrevNextSlideButton;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.text.Font;
import flash.text.TextDisplayMode;
import flash.ui.Keyboard;

import starling.core.Starling;
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

    [Embed(source="/assets/images_design/spritesheet.xml", mimeType="application/octet-stream")]
    public static const ButtonXML:Class;

    [Embed(source="/assets/images_design/spritesheet.png")]
    public static const ButtonTexture:Class;

    [Embed(source="/assets/font/HelveticaNeueLTStd-Roman.otf", embedAsCFF="false", fontFamily="HelveticaNeue")]
    private static const HelveticaNeue:Class;

    [Embed(source="/assets/font/HelveticaNeueLTStd-Bd.otf", embedAsCFF="false", fontFamily="HelveticaNeueBold")]
    private static const HelveticaNeueBold:Class;

    public function Application() {
        trace('[APP] CONSTRUCT');
        appModel = AppModel.getInstance();
        appModel.load();
        appModel.timelineView = true;
        appModel.selectedColorIndex = 0xdd8716;
        appModel.thumbScrollbarPosition = 0;
        this.appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);

        var texture:Texture = Texture.fromBitmap(new ButtonTexture());
        var xml:XML = XML(new ButtonXML());
        textureAtlas = new TextureAtlas(texture, xml);
        bgLoader = new Loader();
        bgLoader.load(new URLRequest("assets/images_design/bg_pattern.png"));
        bgLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, backgroundTextureLoadedHandler);

        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDownEventHandler);
        this.addEventListener("BACKGROUNDINITIALIZING_COMPLETE", backgroundInitializingComplete);
        showEmbeddedFonts();
    }

    public function showEmbeddedFonts():void {
        trace("========Embedded Fonts========");
        var fonts:Array = Font.enumerateFonts();
        fonts.sortOn("fontName", Array.CASEINSENSITIVE);
        for (var i:int = 0; i < fonts.length; i++) {
            trace(fonts[i].fontName + ", " + fonts[i].fontStyle);
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
        pageContainer.x = 30;
        pageContainer.y = 30;
        addChild(pageContainer);

        trace('[APP] AANMAKEN BUTTONS EN PAGECONTAINER');
        previousControl= new PrevNextSlideButton(textureAtlas, "previous");
        nextControl= new PrevNextSlideButton(textureAtlas, "next");
        viewModeController = new ViewModeController(textureAtlas);

        addChild(previousControl);
        addChild(nextControl);
        addChild(viewModeController);
        display();
    }

    private function resizeHandler(event:flash.events.Event):void {
        trace('Resize handler');
        display();
    }

    private function display():void{

        var horizontalReps:Number = appModel.appwidth/originalBgWidth;
        var verticalReps:Number = appModel.appheight/originalBgHeight;
        backgroundImg.setTexCoords(1, new Point(horizontalReps, 0));
        backgroundImg.setTexCoords(2, new Point(0, verticalReps));
        backgroundImg.setTexCoords(3, new Point(horizontalReps, verticalReps));
        backgroundImg.width *= horizontalReps;
        backgroundImg.height *= verticalReps;

        previousControl.y = (appModel.appheight - previousControl.height) >> 1;
        previousControl.x = -previousControl.width/2;
        nextControl.x = appModel.appwidth - nextControl.width/2;
        nextControl.y = (appModel.appheight - nextControl.height) >> 1;
    }
}
}
