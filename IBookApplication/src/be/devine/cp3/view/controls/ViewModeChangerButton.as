/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 16:03
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;

import flash.events.Event;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class ViewModeChangerButton extends Button {
    private var appModel:AppModel;
    private var timelineView:Texture;
    private var gridView:Texture;

    //TODO: control die van timeline naar thumbnail mode switcht
    public function ViewModeChangerButton(timelineView:Texture, gridView:Texture) {
        appModel = AppModel.getInstance();
        super(gridView);
        appModel.timelineView ? this.upState = gridView : this.upState = timelineView;

        this.scaleWhenDown = 1;
        this.timelineView = timelineView;
        this.gridView = gridView;
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
            this.upState = gridView;
        }else{
            this.upState = timelineView;
        }
    }
}
}
