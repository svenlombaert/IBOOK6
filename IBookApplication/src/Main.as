package {

import be.devine.cp3.Application;
import be.devine.cp3.model.AppModel;

import flash.display.Screen;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

import starling.core.Starling;

public class Main extends Sprite {

    private var starling:Starling;

    public function Main() {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.nativeWindow.width = 1024;
        stage.nativeWindow.height = 768;
        stage.nativeWindow.x = (Screen.mainScreen.bounds.width - 1024) >> 1;
        stage.nativeWindow.y = (Screen.mainScreen.bounds.height - 768) >> 1;
        stage.addEventListener(Event.RESIZE, resizeHandler);
        startApplication();
    }

    private function startApplication():void {
        starling = new Starling(Application, stage);
        AppModel.getInstance();
        AppModel.instance.appwidth = stage.stageWidth;
        AppModel.instance.appheight = stage.stageHeight;
        starling.start();
        display();
    }

    private function resizeHandler(event:Event):void {
        display();
    }

    private function display():void{
        var rect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        starling.viewPort = rect;
        starling.stage.stageWidth = stage.stageWidth;
        starling.stage.stageHeight = stage.stageHeight;
    }
}
}
