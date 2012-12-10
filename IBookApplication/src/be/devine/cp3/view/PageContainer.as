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
        trace('[PAGECONTAINER] MAAK PAGINA AAN');
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
        if(appModel.selectedPageIndex > currentPageIndex){
            trace('GA NAAR NEXT');
            currPageview.x = appModel.appwidth;
            addChild(currPageview);
            var tween = new Tween(currPageview, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("x", 0);
            Starling.juggler.add(tween);
        }else{
            trace('GA NAAR PREVIOUS');
            currPageview.x = -appModel.appwidth;
            addChild(currPageview);
            var tween = new Tween(currPageview, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("x", 0);
            Starling.juggler.add(tween);
        }
        currentPageIndex = appModel.selectedPageIndex;
    }

    private function pageIndexChangedHandler(event:Event):void {
        if(appModel.selectedPageIndex > currentPageIndex){
            trace('[PAGECONTAINER][next] TWEEN CURRPAGE')
            var tween = new Tween(currPageview, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("x", -appModel.appwidth);
            tween.onComplete = switchPages;
            Starling.juggler.add(tween);
        }else{
            trace('[PAGECONTAINER][previous] TWEEN CURRPAGE')
            var tween = new Tween(currPageview, 0.5, Transitions.EASE_IN_OUT);
            tween.animate("x", appModel.appwidth);
            tween.onComplete = switchPages;
            Starling.juggler.add(tween);
        }
    }


}
}