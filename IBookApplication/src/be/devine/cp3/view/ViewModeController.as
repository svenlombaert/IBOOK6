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
import be.devine.cp3.view.controls.ViewModeChangerButton;
import be.devine.cp3.view.controls.ViewModeOpenButton;
import be.devine.cp3.view.viewmodes.ThumbnailContainer;

import flash.events.Event;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
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
        openControl.addEventListener(ViewModeOpenButton.VIEWMODE_OPENED, openControlClicked);
        changeViewModeControl.addEventListener(ViewModeChangerButton.VIEWMODE_CHANGED, changeViewModeControlClicked);

        if(appModel.timelineView){
            _maxItemsToView = appModel.maxItemsToView = 4;
            if(_maxItemsToView < appModel.pages.length){
                //TODO: luisteren naar klik event op de pagina's.
                scrollbar = new Scrollbar(appModel.appwidth - 60, 10, ((appModel.appwidth-60)/appModel.pages.length) * _maxItemsToView);
                scrollbar.addEventListener(Scrollbar.THUMBPOSITION_CHANGED, scrollbarDragHandler);
            }
        }else{
            _maxItemsToView = appModel.maxItemsToView = 16;
            if(_maxItemsToView < appModel.pages.length){
                //Scrollbar aanmaken
                scrollbar = new Scrollbar(appModel.appwidth - 60, 10, ((appModel.appwidth-60)/appModel.pages.length) * _maxItemsToView);
                scrollbar.addEventListener(Scrollbar.THUMBPOSITION_CHANGED, scrollbarDragHandler);
            }
        }
        changeViewModeControl.y = openControl.height;
        timeLineButtonsContainer.addChild(openControl);
        timeLineButtonsContainer.addChild(changeViewModeControl);

        display();

        addChild(thumbnailContainer);
        addChild(timeLineButtonsContainer);
        if(scrollbar != null){
            addChild(scrollbar);
        }
        this.appModel.addEventListener(AppModel.VIEWMODES_OPENED, viewModesOpenedHandler);
        this.appModel.addEventListener(AppModel.VIEWMODES_CHANGED, viewModesChangedHandler);
        this.appModel.addEventListener(AppModel.THUMBSCROLLBARPOSITION_CHANGED, scrollbarPosChanged);
    }
    private function viewModesOpenedHandler(event:flash.events.Event):void {
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

    private function viewModesChangedHandler(event:flash.events.Event):void {
        Starling.juggler.removeTweens(this);
        Starling.juggler.removeTweens(openControl);
        Starling.juggler.removeTweens(thumbnailContainer);
        changeViewModeControl.viewModeTimeline = appModel.timelineView;
        //de viewmodes staan altijd open
        //changeViewModeControl.viewModeTimeline = appModel.timelineView;
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

    private function resizeHandler(event:flash.events.Event):void {
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

        }else{
            thumbnailContainer.y = appModel.appheight;
            timeLineButtonsContainer.y = appModel.appheight;
        }

        if(scrollbar != null){
            if(appModel.viewModesOpened){
                scrollbar.y = appModel.appheight - scrollbar.height;
            }else{
                scrollbar.y = appModel.appheight;
            }
            scrollbar.x = appModel.appwidth/2 - scrollbar.width/2;
        }

        timeLineButtonsContainer.pivotX = timeLineButtonsContainer.width/2;
        timeLineButtonsContainer.pivotY = timeLineButtonsContainer.height/2;
        timeLineButtonsContainer.x = appModel.appwidth/2;
    }

    private function scrollbarDragHandler(event:starling.events.Event):void {
        appModel.thumbScrollbarPosition = scrollbar.thumbPosition;
    }

    private function openControlClicked(event:starling.events.Event):void {
        appModel.openViewModes();
    }

    private function changeViewModeControlClicked(event:starling.events.Event):void {
        appModel.changeViewModes();
    }

    private function scrollbarPosChanged(event:flash.events.Event):void {
        scrollbar.thumbPosition = appModel.thumbScrollbarPosition;
    }
}
}
