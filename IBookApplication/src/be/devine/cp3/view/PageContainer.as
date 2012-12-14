/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 7/12/12
 * Time: 15:05
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.vo.PageVO;

import flash.events.Event;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Sprite;

public class PageContainer extends Sprite{

    private var appModel:AppModel;
    private var pages:Vector.<PageVO>;
    private var currPageview:Page;
    private var currentPageIndex:int;
    private var tween:Tween;
    //TODO: spammen op de linker en rechter knop
    public function PageContainer() {
        appModel = AppModel.getInstance();
        currentPageIndex = appModel.selectedPageIndex = 0;
        this.appModel.addEventListener(AppModel.PAGES_CHANGED, pagesChangedHandler);
        this.appModel.addEventListener(AppModel.SELECTEDPAGEINDEX_CHANGED, pageIndexChangedHandler);
        initialisePagesToView();
    }

    private function pagesChangedHandler(event:Event):void {
        initialisePagesToView();
    }

    private function initialisePagesToView():void {
        this.removeChildren();
        this.dispose();
        pages = appModel.pages;
        currPageview = new Page(pages[currentPageIndex]);
        addChild(currPageview);
    }

    private function switchPages():void {
        this.removeChildren();
        this.dispose();
        currPageview = new Page(pages[appModel.selectedPageIndex]);
        var tween:Tween;
        if(appModel.selectedPageIndex > currentPageIndex){
            currPageview.x = appModel.appwidth;
            addChild(currPageview);
            tween = new Tween(currPageview, 0.3, Transitions.EASE_IN_OUT);
            tween.animate("x", 0);
            Starling.juggler.add(tween);
        }else{
            currPageview.x = -appModel.appwidth;
            addChild(currPageview);
            tween = new Tween(currPageview, 0.3, Transitions.EASE_IN_OUT);
            tween.animate("x", 0);
            Starling.juggler.add(tween);
        }
        currentPageIndex = appModel.selectedPageIndex;
    }

    private function pageIndexChangedHandler(event:Event):void {
        var tween:Tween;
        if(appModel.selectedPageIndex > currentPageIndex){
            tween = new Tween(currPageview, 0.3, Transitions.EASE_IN_OUT);
            tween.animate("x", -appModel.appwidth);
            tween.onComplete = switchPages;
            Starling.juggler.add(tween);
        }else{
            tween = new Tween(currPageview, 0.3, Transitions.EASE_IN_OUT);
            tween.animate("x", appModel.appwidth);
            tween.onComplete = switchPages;
            Starling.juggler.add(tween);
        }
    }


}
}