/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 7/12/12
 * Time: 15:05
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.utils.memory.ClearMemory;
import be.devine.cp3.vo.PageVO;

import flash.events.Event;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;

public class PageContainer extends Sprite{

    private var appModel:AppModel;
    private var pages:Vector.<PageVO>;
    private var loadedPages:Array;
    private var currentPageIndex:int;
    private var pageToDelete:Page;
    //TODO: spammen op de linker en rechter knop
    public function PageContainer() {

        appModel = AppModel.getInstance();
        currentPageIndex = appModel.selectedPageIndex;
        this.appModel.addEventListener(AppModel.PAGES_CHANGED, pagesChangedHandler);
        this.appModel.addEventListener(AppModel.SELECTEDPAGEINDEX_CHANGED, pageIndexChangedHandler);
        initialisePagesToView();
    }

    private function pagesChangedHandler(event:Event):void {
        initialisePagesToView();
    }

    private function initialisePagesToView():void {
        //TODO: memory clearen
        ClearMemory.clear(this);
        loadedPages = new Array();
        pages = appModel.pages;
        buildPages();
        addChild(loadedPages[1]);
    }

    private function pageIndexChangedHandler(event:Event):void {
        var diff:int = currentPageIndex - appModel.selectedPageIndex;

            if((diff>= -1) && (diff<=1))
            {
                if(appModel.selectedPageIndex > currentPageIndex){
                    gotoNextPage();
                }else{
                    gotoPreviousPage();
                }

            }else{
                buildPages();
            }


    }

    private function gotoNextPage():void{
        pageToDelete = loadedPages[1];
        currentPageIndex = appModel.selectedPageIndex;

        if(appModel.hasNextPage){
            loadedPages.push(new Page(appModel.pages[currentPageIndex +1]));

        }else{
            loadedPages.shift();
        }

        if(loadedPages.length > 3){
            trace('array length: ', loadedPages.length);
            if(loadedPages[0] != null){
                trace('dispose loadedPages[0]');
                trace('----start clear memory----');
                ClearMemory.clear(loadedPages[0] as DisplayObjectContainer);
                trace('----end clear memory----');
                loadedPages[0].dispose();
            }
            loadedPages.shift();
            trace('array length: ', loadedPages.length);
        }

        loadedPages[1].x = appModel.appwidth;
        addChild(loadedPages[1]);
        var tween1:Tween = new Tween(loadedPages[1], 0.4, Transitions.EASE_OUT);
        tween1.animate("x", 0);
        var tween2:Tween = new Tween(pageToDelete, 0.4, Transitions.EASE_OUT);
        tween2.animate("x", -appModel.appwidth);
        tween2.onComplete = removeItems;
        tween2.onCompleteArgs = new Array(pageToDelete);
        Starling.juggler.add(tween1);
        Starling.juggler.add(tween2);
    }

    private function gotoPreviousPage():void{
        currentPageIndex = appModel.selectedPageIndex;
        pageToDelete = loadedPages[1];

        if(appModel.hasPreviousPage){
            loadedPages.unshift(new Page(appModel.pages[appModel.selectedPageIndex-1]));

        }else{
            loadedPages.unshift(new Page(appModel.pages[appModel.selectedPageIndex]));
        }

        if(loadedPages.length > 3){
            trace('array length: ', loadedPages.length);

            if(loadedPages[3] != null){
                trace('dispose loadedPages[3]');
                trace('----start clear memory----');
                ClearMemory.clear(loadedPages[3] as DisplayObjectContainer);
                trace('----end clear memory----');
                loadedPages[3].dispose();
            }
            loadedPages.pop();
            trace('array length: ', loadedPages.length);

        }

        loadedPages[1].x = -appModel.appwidth;
        addChild(loadedPages[1]);
        var tween1:Tween = new Tween(loadedPages[1], 0.4, Transitions.EASE_OUT);
        tween1.animate("x", 0);
        var tween2:Tween = new Tween(pageToDelete, 0.4, Transitions.EASE_OUT);
        tween2.animate("x", appModel.appwidth);
        tween2.onComplete = removeItems;
        tween2.onCompleteArgs = new Array(pageToDelete);
        Starling.juggler.add(tween1);
        Starling.juggler.add(tween2);
    }

    private function buildPages():void{
        pageToDelete = loadedPages[1];
        currentPageIndex = appModel.selectedPageIndex;
        if(appModel.hasNextPage){
            if(loadedPages[2] != null){
                ClearMemory.clear(loadedPages[2] as DisplayObjectContainer);
                loadedPages[2].dispose();
            }
            loadedPages[2] = new Page(appModel.pages[currentPageIndex+1]);
        }
        if(appModel.hasPreviousPage){
            if(loadedPages[0] != null){
                ClearMemory.clear(loadedPages[0] as DisplayObjectContainer);
                loadedPages[0].dispose();
            }
            loadedPages[0] = new Page(appModel.pages[currentPageIndex-1]);
        }
        if(loadedPages[1] != null){
            ClearMemory.clear(loadedPages[1] as DisplayObjectContainer);
            loadedPages[1].dispose();
        }

        loadedPages[1] = new Page(appModel.pages[currentPageIndex]);
        loadedPages[1].alpha = 0;
        addChild(loadedPages[1]);

        var tween:Tween = new Tween(loadedPages[1], 0.4, Transitions.EASE_IN);
        tween.animate("alpha", 1);
        tween.onComplete = removeItems;
        tween.onCompleteArgs = new Array(pageToDelete);
        Starling.juggler.add(tween);
    }

    private function removeItems(pageToDelete:Page):void {
        if(pageToDelete != null){
            removeChild(pageToDelete);
        }
    }

}
}