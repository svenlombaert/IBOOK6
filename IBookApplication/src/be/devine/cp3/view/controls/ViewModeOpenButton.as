/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 30/11/12
 * Time: 15:42
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;

import flash.display.BitmapData;
import flash.display.Shape;

import starling.animation.Tween;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class ViewModeOpenButton extends Button{

    private var appModel:AppModel;
    private var tween:Tween;
    private var textureAtlas:TextureAtlas;

    private var _updateListeners:Boolean = false;

    public function ViewModeOpenButton(textureAtlas:TextureAtlas) {
        appModel = AppModel.getInstance();
        super(renderTexture(textureAtlas, appModel.selectedColorIndex));
        this.textureAtlas = textureAtlas;
        this.scaleWhenDown = 1;
        this.addEventListener(TouchEvent.TOUCH, touchHandler);
    }

    //TODO: Sven: Bug oplossen bij snel klikken
    private function touchHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        if(event.getTouch(touchObject, TouchPhase.BEGAN)){
            appModel.openViewModes();
        }
    }

    private function renderTexture(textureAtlas: TextureAtlas, color: uint):Texture {
        var circleShape:Shape = new Shape();
        circleShape.graphics.beginFill(color, 0.8);
        circleShape.graphics.drawCircle(50,50,50);
        circleShape.graphics.endFill();

        var arrow:Texture = textureAtlas.getTexture("arrow");
        var imgArrow:Image = new Image(arrow);
        imgArrow.pivotX = imgArrow.width/2;
        imgArrow.pivotY = imgArrow.height/2;
        imgArrow.x = circleShape.width/2;
        imgArrow.y = circleShape.width/2 - 30;

        var bmpData:BitmapData = new BitmapData(circleShape.width, circleShape.height/2, true, 0x000000);
        bmpData.draw(circleShape);

        var imgCircle:Image = new Image(Texture.fromBitmapData(bmpData));

        var renderTexture:RenderTexture = new RenderTexture(circleShape.width, circleShape.height/2);
        renderTexture.draw(imgCircle);
        renderTexture.draw(imgArrow);

        return renderTexture;
    }

    //getters en setters
    public function set updateListeners(value:Boolean):void {
        _updateListeners = value;

        if(_updateListeners){
            this.removeEventListener(TouchEvent.TOUCH, touchHandler);
        }else{
            this.addEventListener(TouchEvent.TOUCH, touchHandler);
        }
    }

}
}
