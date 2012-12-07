/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 16:03
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.events.Event;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.deg2rad;

public class ViewModeChangerButton extends Button {
    private var appModel:AppModel;
    private var textureAtlas:TextureAtlas;

    //TODO: control die van timeline naar thumbnail mode switcht
    public function ViewModeChangerButton(textureAtlas:TextureAtlas) {
        appModel = AppModel.getInstance();
        super(renderTexture(textureAtlas, appModel.selectedColorIndex));
        this.textureAtlas = textureAtlas;
        this.scaleWhenDown = 1;
        this.addEventListener(TouchEvent.TOUCH, touchHandler);
        this.appModel.addEventListener(AppModel.VIEWMODES_CHANGED, viewmodeChangedHandler);
    }

    private function touchHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        if(event.getTouch(touchObject, TouchPhase.BEGAN)){
            appModel.changeViewModes();
        }
    }

    private function viewmodeChangedHandler(event:Event):void {
        trace("TIMELINEVIEW: ", appModel.timelineView);
        if(appModel.timelineView){
            this.upState = renderTexture(textureAtlas, appModel.selectedColorIndex);
        }else{
            this.upState = renderTexture(textureAtlas, appModel.selectedColorIndex);
        }
    }

    private function renderTexture(textureAtlas: TextureAtlas, color: uint): Texture {
        var circleShape:Shape = new Shape();
        circleShape.graphics.beginFill(color, 0.8);
        circleShape.graphics.drawCircle(50,50,50);
        circleShape.graphics.endFill();

        if(appModel.timelineView){
            var icon:Texture = textureAtlas.getTexture("gridIcon");
        }else{
            var icon:Texture = textureAtlas.getTexture("timelineIcon");
        }
        var imgIcon:Image = new Image(icon);

        imgIcon.pivotX = imgIcon.width/2;
        imgIcon.pivotY = imgIcon.height/2;
        imgIcon.scaleX = 0.9;
        imgIcon.scaleY = 0.9;
        imgIcon.rotation = deg2rad(180);
        imgIcon.x = circleShape.width/2;
        imgIcon.y = circleShape.width/2 - 25;

        var bmpData:BitmapData = new BitmapData(circleShape.width, circleShape.height/2, true, 0x000000);
        bmpData.draw(circleShape);

        var imgCircle:Image = new Image(Texture.fromBitmapData(bmpData));
        //imgCircle.pivotX = circleShape.width;
        //imgCircle.pivotY = circleShape.width;
        //imgCircle.rotation = deg2rad(180);
        imgCircle.pivotX = 0;
        imgCircle.pivotY = imgCircle.height;
        imgCircle.scaleY = -1;

        var renderTexture:RenderTexture = new RenderTexture(circleShape.width, circleShape.height/2);
        renderTexture.draw(imgCircle);
        renderTexture.draw(imgIcon);

        return renderTexture;
    }
}
}
