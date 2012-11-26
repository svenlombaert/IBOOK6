package {

import be.devine.cp3.Application;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.utils.getDefinitionByName;

import starling.core.Starling;
import starling.display.DisplayObject;

public class Main extends MovieClip {

    private var app:starling.display.DisplayObject;
    private var starling:Starling;

    public function Main() {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;



        if(loaderInfo.bytesLoaded >= loaderInfo.bytesTotal){
            startApplication();
        }else{
            loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
        }
    }

    private function startApplication():void {
        gotoAndStop('start');
        starling = new Starling(Application, stage);
        starling.start();
    }

    private function progressHandler(event:ProgressEvent):void {
        trace('LOADING')
        trace(event.bytesLoaded, event.bytesTotal);
    }

    private function completeHandler(event:Event):void {
        startApplication();
    }

}
}
