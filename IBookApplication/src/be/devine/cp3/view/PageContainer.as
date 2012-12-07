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

import starling.display.Sprite;

public class PageContainer extends Sprite{

    private var appModel:AppModel;
    private var pages:Vector.<PageVO>;
    private var currPageview:Page;
    private var currentPageIndex:int;

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
        this.dispose();
        pages = appModel.pages;
        currPageview = new Page(pages[currentPageIndex]);
        addChild(currPageview);
    }

    private function pageIndexChangedHandler(event:Event):void {
        currentPageIndex = appModel.selectedPageIndex;
        initialisePagesToView();
    }
}
}
