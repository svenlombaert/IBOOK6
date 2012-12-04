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

public class ViewModeController extends Sprite {
    private var openControl:ViewModeOpenButton;
    private var changeViewModeControl:ViewModeChangerButton;
    private var thumbnailContainer:ThumbnailContainer;
    private var appModel:AppModel;
    private var tween:Tween;

    public function ViewModeController(textureAtlas:TextureAtlas) {
        appModel = AppModel.getInstance();
        openControl = new ViewModeOpenButton(textureAtlas.getTexture("up"), textureAtlas.getTexture("upopen"));
        thumbnailContainer = new ThumbnailContainer();
        changeViewModeControl = new ViewModeChangerButton(textureAtlas.getTexture("timelinecontrol"), textureAtlas.getTexture("gridcontrol"));

        openControl.x = (appModel.appwidth-openControl.width) >>1;
        openControl.y = appModel.appheight - openControl.height;
        thumbnailContainer.y = appModel.appheight;
        changeViewModeControl.x = (appModel.appwidth - openControl.width) >> 1;
        changeViewModeControl.y = appModel.appheight;

        addChild(thumbnailContainer);
        addChild(openControl);
        addChild(changeViewModeControl);
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
                tween = new Tween(openControl, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight - 258 - openControl.height);
                Starling.juggler.add(tween);
                tween = new Tween(changeViewModeControl, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight - 258);
                Starling.juggler.add(tween);
                tween.onComplete = checkListeners;
            }else{
                //sluit het
                trace('TIMELINE CLOSE');
                tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                Starling.juggler.add(tween);
                tween = new Tween(openControl, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight - openControl.height);
                Starling.juggler.add(tween);
                tween = new Tween(changeViewModeControl, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                Starling.juggler.add(tween);
                tween.onComplete = checkListeners;
            }
        }else{
            //if gridview, tween helemaal naar boven
            if(appModel.viewModesOpened){
                //open het
                trace('GRIDVIEW OPEN');
                tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", 0);
                Starling.juggler.add(tween);
                tween = new Tween(openControl, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", 10);
                Starling.juggler.add(tween);
                tween = new Tween(changeViewModeControl, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", 10 + openControl.height);
                Starling.juggler.add(tween);
                tween.onComplete = checkListeners;

            }else{
                //sluit het
                trace('GRIDVIEW CLOSE');
                tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                Starling.juggler.add(tween);
                tween = new Tween(openControl, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight - openControl.height);
                Starling.juggler.add(tween);
                tween = new Tween(changeViewModeControl, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
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
            tween = new Tween(openControl, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", appModel.appheight - 258 - openControl.height);
            Starling.juggler.add(tween);
            tween = new Tween(changeViewModeControl, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", appModel.appheight - 258);
            Starling.juggler.add(tween);
        }else{
            //naar gridview gaan
            trace(thumbnailContainer.y);
            tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", 0);
            Starling.juggler.add(tween);
            tween = new Tween(openControl, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", 10);
            Starling.juggler.add(tween);
            tween = new Tween(changeViewModeControl, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("y", 10 + openControl.height);
            Starling.juggler.add(tween);
        }
    }

}
}
