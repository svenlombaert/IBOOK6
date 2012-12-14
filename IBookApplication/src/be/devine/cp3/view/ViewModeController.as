/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 14:25
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.view.controls.Scrollbar;
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
    private var scrollbar:Scrollbar;
    private var _maxItemsToView:int;

    public function ViewModeController(textureAtlas:TextureAtlas) {
        appModel = AppModel.getInstance();
        openControl = new ViewModeOpenButton(textureAtlas);
        thumbnailContainer = new ThumbnailContainer(textureAtlas);
        changeViewModeControl = new ViewModeChangerButton(textureAtlas);
        timeLineButtonsContainer = new Sprite();
        this.appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);

        if(appModel.timelineView){
            _maxItemsToView = appModel.maxItemsToView = 4;
            if(_maxItemsToView < appModel.pages.length){
                scrollbar = new Scrollbar(appModel.appwidth - 60, 10, ((appModel.appwidth-60)/appModel.pages.length) * _maxItemsToView);
            }
        }else{
            _maxItemsToView = appModel.maxItemsToView = 16;
            if(_maxItemsToView < appModel.pages.length){
                //Scrollbar aanmaken
            }
        }
        changeViewModeControl.y = openControl.height;
        timeLineButtonsContainer.addChild(openControl);
        timeLineButtonsContainer.addChild(changeViewModeControl);

        display();

        addChild(thumbnailContainer);
        addChild(timeLineButtonsContainer);
        addChild(scrollbar);
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
                //TIMELINEVIEW OPENEN
                tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight - 258);
                Starling.juggler.add(tween);

                tween = new Tween(timeLineButtonsContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight - 258);
                tween.animate("rotation", deg2rad(180));
                Starling.juggler.add(tween);

                if(scrollbar != null){
                    tween = new Tween(scrollbar, 0.5, Transitions.EASE_IN_BOUNCE);
                    tween.animate("y", appModel.appheight - scrollbar.height);
                    Starling.juggler.add(tween);
                }
                tween.onComplete = checkListeners;
            }else{
                //TIMELINEVIEW SLUITEN
                tween = new Tween(thumbnailContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                Starling.juggler.add(tween);

                tween = new Tween(timeLineButtonsContainer, 0.5, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                tween.animate("rotation", deg2rad(0));
                Starling.juggler.add(tween);

                if(scrollbar != null){
                    tween = new Tween(scrollbar, 0.1, Transitions.EASE_IN_BOUNCE);
                    tween.animate("y", appModel.appheight);
                    Starling.juggler.add(tween);
                }

                tween.onComplete = checkListeners;
            }
        }else{
            //if gridview, tween helemaal naar boven
            if(appModel.viewModesOpened){
                //GRIDVIEW OPENEN
                tween = new Tween(thumbnailContainer, 0.7, Transitions.EASE_IN_OUT);
                tween.animate("y", 0);
                Starling.juggler.add(tween);

                tween = new Tween(timeLineButtonsContainer, 0.7, Transitions.EASE_IN_OUT);
                tween.animate("y", 10 + timeLineButtonsContainer.height/2);
                tween.animate("rotation", deg2rad(180));
                Starling.juggler.add(tween);

                if(scrollbar !=null){
                    tween = new Tween(scrollbar, 0.5, Transitions.EASE_IN_BOUNCE);
                    tween.animate("y", appModel.appheight - scrollbar.height);
                    Starling.juggler.add(tween);
                }

                tween.onComplete = checkListeners;

            }else{
                //GRIDVIEW SLUITEN
                tween = new Tween(thumbnailContainer, 0.7, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                Starling.juggler.add(tween);

                tween = new Tween(timeLineButtonsContainer, 0.7, Transitions.EASE_IN_OUT);
                tween.animate("y", appModel.appheight);
                tween.animate("rotation", deg2rad(0));
                Starling.juggler.add(tween);

                if(scrollbar !=null){
                    tween = new Tween(scrollbar, 0.1, Transitions.EASE_IN_BOUNCE);
                    tween.animate("y", appModel.appheight);
                    Starling.juggler.add(tween);
                }

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

    private function resizeHandler(event:Event):void {
        display();
    }

    private function display():void{
        if(appModel.viewModesOpened){
            if(appModel.timelineView){
                thumbnailContainer.y = appModel.appheight - 258;
                timeLineButtonsContainer.y = appModel.appheight - 258;
            }else{
                timeLineButtonsContainer.y = 10 + timeLineButtonsContainer.height/2;
                thumbnailContainer.y = 0;
            }
            scrollbar.y = appModel.appheight - scrollbar.height;
        }else{
            thumbnailContainer.y = appModel.appheight;
            timeLineButtonsContainer.y = appModel.appheight;
            scrollbar.y = appModel.appheight;
        }

        scrollbar.x = appModel.appwidth/2 - scrollbar.width/2;

        timeLineButtonsContainer.pivotX = timeLineButtonsContainer.width/2;
        timeLineButtonsContainer.pivotY = timeLineButtonsContainer.height/2;
        timeLineButtonsContainer.x = appModel.appwidth/2;
    }
}
}
