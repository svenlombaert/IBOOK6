/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3 {


import be.devine.cp3.controls.ControlButton;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.queue.ImageLoaderTask;
import be.devine.cp3.queue.Queue;

import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Application extends Sprite {

    private var appModel:AppModel;
    private var queue:Queue;
    private var bgContainer:Sprite;

    [Embed(source="/assets/images_design/spritesheet.xml", mimeType="application/octet-stream")]
    public static const ButtonXML:Class;

    [Embed(source="/assets/images_design/spritesheet.png")]
    public static const ButtonTexture:Class;

    public function Application() {
        trace('[APP] CONSTRUCT');
        appModel = AppModel.getInstance();
        queue = new Queue();
        queue.add(new ImageLoaderTask(AppModel.IMAGES_DESIGN_PATH + "bg_pattern.png"));
        queue.addEventListener(flash.events.Event.COMPLETE, queueCompleteHandler);
        queue.start();

        this.addEventListener(KeyboardEvent.KEY_DOWN, keyBoardEventHandler);
        this.addEventListener("BACKGROUNDINITIALIZING_COMPLETE", backgroundInitializingComplete);
    }

    //----METHODS
    private function queueCompleteHandler(event:flash.events.Event):void {
        var completedTask:ImageLoaderTask = queue.completedTasks[0] as ImageLoaderTask;
        var bgBitmapData:BitmapData = new BitmapData(completedTask.width, completedTask.height);
        bgBitmapData.draw(completedTask.content);
        var texture:Texture = Texture.fromBitmapData(bgBitmapData);
        texture.repeat = true;
        var img:Image = new Image(texture);
        var horizontalReps:Number = stage.stageWidth/img.width;
        var verticalReps:Number = stage.stageHeight/img.height;
        //tiled background code
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
        var texture:Texture = Texture.fromBitmap(new ButtonTexture());
        var xml:XML = XML(new ButtonXML());
        var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
        var textureLeft:Texture = textureAtlas.getTexture("left");

        trace(textureAtlas.getTexture("left"));
        var previousControl:ControlButton = new ControlButton(textureAtlas.getTexture("left"), "previous");
        var nextControl:ControlButton = new ControlButton(textureAtlas.getTexture("right"), "next");
        var upControl:ControlButton = new ControlButton(textureAtlas.getTexture("up"), "viewmode");
        previousControl.y = (stage.stageHeight - previousControl.height) >> 1;
        nextControl.x = stage.stageWidth - nextControl.width;
        nextControl.y = (stage.stageHeight - nextControl.height) >> 1;
        upControl.x = (stage.stageWidth-upControl.width) >>1;
        upControl.y = stage.stageHeight - upControl.height;
        addChild(previousControl);
        addChild(nextControl);
        addChild(upControl);

    }
}
}
