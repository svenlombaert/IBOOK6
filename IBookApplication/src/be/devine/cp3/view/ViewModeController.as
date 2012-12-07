/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 14:25
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.view.controls.ThumbnailContainer;
import be.devine.cp3.view.controls.ViewModeChangerButton;
import be.devine.cp3.view.controls.ViewModeOpenButton;

import flash.events.Event;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Sprite;
import starling.textures.TextureAtlas;
import starling.utils.deg2rad;

//TODO bol volledig laten draaien (upcontrol, logo timelineview dus omdraaien)
public class ViewModeController extends Sprite {
    private var openControl:ViewModeOpenButton;
    private var changeViewModeControl:ViewModeChangerButton;
    private var thumbnailContainer:ThumbnailContainer;
    private var appModel:AppModel;
    private var tween:Tween;
    private var timeLineButtonsContainer:Sprite;

    public function ViewModeController(textureAtlas:TextureAtlas) {
        appModel = AppModel.getInstance();
        openControl = new ViewModeOpenButton(textureAtlas);
        thumbnailContainer = new ThumbnailContainer();
        changeViewModeControl = new ViewModeChangerButton(textureAtlas);
        timeLineButtonsContainer = new Sprite();

        thumbnailContainer.y = appModel.appheight;
        changeViewModeControl.y = openControl.height;

        timeLineButtonsContainer.addChild(openControl);
        timeLineButtonsContainer.addChild(changeViewModeControl);
        timeLineButtonsContainer.pivotX = timeLineButtonsContainer.width/2;
        timeLineButtonsContainer.pivotY = timeLineButtonsContainer.height/2;
        timeLineButtonsContainer.x = appModel.appwidth/2;
        timeLineButtonsContainer.y = appModel.appheight;

        addChild(thumbnailContainer);
        addChild(timeLineButtonsContainer);
        this.appModel.addEventListener(AppModel.VIEWMODES_OPENED, viewModesOpenedHandler);
        this.appModel.addEventListener(AppModel.VIEWMODES_CHANGED, viewModesChangedHandler);
    }
    //TODO: openControl en changeviewmodecontrol in 1 container steken
    //TODO: pijltjes toevoegen
    private function viewModesOpenedHandler(event:Event):void {
        Starling.juggler.removeTweens(this);
        Starling.juggler.removeTweens(openControl);
        Starling.juggler.removeTweens(thumbnailContainer);
        openControl.updateListeners = true;
        if(appModel.timelineView){
            if(appModel.viewModesOpened){
                //open het
                trace('TIMELINE OPEN');
                tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight - 258);
                Starling.juggler.add(tween);
                tween = new Tween(timeLineButtonsContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight - 258);
                tween.animate("rotation", deg2rad(180));
                Starling.juggler.add(tween);
                tween.onComplete = checkListeners;
            }else{
                //sluit het
                trace('TIMELINE CLOSE');
                tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                Starling.juggler.add(tween);
                tween = new Tween(timeLineButtonsContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                tween.animate("rotation", deg2rad(0));
                Starling.juggler.add(tween);
                tween.onComplete = checkListeners;
            }
        }else{
            //if gridview, tween helemaal naar boven
            if(appModel.viewModesOpened){
                //open het
                trace('GRIDVIEW OPEN');
                tween = new Tween(thumbnailContainer, 0.7, Transitions.EASE_IN_OUT);
                tween.animate("y", 0);
                Starling.juggler.add(tween);
                tween = new Tween(timeLineButtonsContainer, 0.7, Transitions.EASE_IN_OUT);
                tween.animate("y", 10 + timeLineButtonsContainer.height/2);
                tween.animate("rotation", deg2rad(180));
                Starling.juggler.add(tween);
                tween.onComplete = checkListeners;

            }else{
                //sluit het
                trace('GRIDVIEW CLOSE');
                tween = new Tween(thumbnailContainer, 0.7, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                Starling.juggler.add(tween);
                tween = new Tween(timeLineButtonsContainer, 0.7, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                tween.animate("rotation", deg2rad(0));
                Starling.juggler.add(tween);
                tween.onComplete = checkListeners;
            }
        }
    }

    private function checkListeners():void{
        openControl.updateListeners = false;
    }

    private function viewModesChangedHandler(event:Event):void {
        Starling.juggler.removeTweens(this);
        Starling.juggler.removeTweens(openControl);
        Starling.juggler.removeTweens(thumbnailContainer);
        //de viewmodes staan altijd open
        if(appModel.timelineView){
            //naar timelineview gaan
            tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", appModel.appheight - 258);
            Starling.juggler.add(tween);
            tween = new Tween(timeLineButtonsContainer, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", appModel.appheight - 258);
            Starling.juggler.add(tween);
        }else{
            //naar gridview gaan
            trace(thumbnailContainer.y);
            tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", 0);
            Starling.juggler.add(tween);
            tween = new Tween(timeLineButtonsContainer, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", 10 + timeLineButtonsContainer.height/2);
            Starling.juggler.add(tween);
        }
    }

}
}
