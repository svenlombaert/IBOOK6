/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3 {


import be.devine.cp3.view.Page;
import be.devine.cp3.view.ViewModeController;
import be.devine.cp3.view.controls.PrevNextSlideButton;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.queue.ImageLoaderTask;
import be.devine.cp3.queue.Queue;
import be.devine.cp3.vo.PageVO;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;
import flash.geom.Point;
import flash.net.URLRequest;

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
    private var bgLoader:Loader;

    [Embed(source="/assets/images_design/spritesheet.xml", mimeType="application/octet-stream")]
    public static const ButtonXML:Class;

    [Embed(source="/assets/images_design/spritesheet.png")]
    public static const ButtonTexture:Class;

    public function Application() {
        trace('[APP] CONSTRUCT');
        appModel = AppModel.getInstance();
        appModel.load();
        appModel.timelineView = true;

        var texture:Texture = Texture.fromBitmap(new ButtonTexture());
        var xml:XML = XML(new ButtonXML());
        textureAtlas = new TextureAtlas(texture, xml);
        bgLoader = new Loader();
        bgLoader.load(new URLRequest("assets/images_design/bg_pattern.png"));
        bgLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, backgroundLoadedHandler);

        this.addEventListener(KeyboardEvent.KEY_DOWN, keyBoardEventHandler);
        this.addEventListener("BACKGROUNDINITIALIZING_COMPLETE", backgroundInitializingComplete);
    }

    //----METHODS
    private function backgroundLoadedHandler(event:flash.events.Event):void {
        var texture:Texture = Texture.fromBitmap(bgLoader.content as Bitmap);
        var img:Image = new Image(texture);
        //tileable background
        texture.repeat = true;
        var horizontalReps:Number = appModel.appwidth/img.width;
        var verticalReps:Number = appModel.appheight/img.height;
        img.setTexCoords(1, new Point(horizontalReps, 0));
        img.setTexCoords(2, new Point(0, verticalReps));
        img.setTexCoords(3, new Point(horizontalReps, verticalReps));
        img.width *= horizontalReps;
        img.height *= verticalReps;
        bgContainer = new Sprite();
        bgContainer.addChild(img);
        addChild(bgContainer);
        dispatchEvent(new starling.events.Event("BACKGROUNDINITIALIZING_COMPLETE"));
    }

    private function keyBoardEventHandler(event:flash.events.Event):void {
        //keyboard event om door de pagina's te gaan.
    }

    private function backgroundInitializingComplete(event:starling.events.Event):void {
        //initialize all buttons via button spritesheet
        trace('[APP] AANMAKEN BUTTONS');
        previousControl= new PrevNextSlideButton(textureAtlas, "previous");
        //nextControl= new PrevNextSlideButton(textureAtlas.getTexture("right"), "next");
        //viewModeController = new ViewModeController(textureAtlas);

        previousControl.y = (stage.stageHeight - previousControl.height) >> 1;
        previousControl.x = -previousControl.width/2;
        //nextControl.x = stage.stageWidth - nextControl.width;
        //nextControl.y = (stage.stageHeight - nextControl.height) >> 1;

        addChild(previousControl);
        //addChild(nextControl);
        //addChild(viewModeController);

        maakPaginas();

    }

    private function maakPaginas(){
        var pages:Vector.<PageVO> = appModel.pages;

            trace('MAAK PAGINA AAN');
            var pageView = new Page(pages[0]);
            addChildAt(pageView, this.numChildren -1);
        pageView.x = 20;
        pageView.y = 20;
        trace("pageview height: ", pageView.height);
        }
    }

}
