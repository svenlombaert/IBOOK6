/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:00
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view {
import be.devine.cp3.factory.view.ElementViewFactory;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.view.elements.BackgroundPhotoElement;
import be.devine.cp3.view.elements.BodyTextElement;
import be.devine.cp3.view.elements.Element;
import be.devine.cp3.view.elements.IntroTextElement;
import be.devine.cp3.view.elements.LinkElement;
import be.devine.cp3.view.elements.PageNumberElement;
import be.devine.cp3.view.elements.SubTitleElement;
import be.devine.cp3.view.elements.TitleElement;
import be.devine.cp3.vo.BodyTextElementVO;
import be.devine.cp3.vo.ElementVO;
import be.devine.cp3.vo.IntroTextElementVO;
import be.devine.cp3.vo.LinkElementVO;
import be.devine.cp3.vo.PageVO;
import be.devine.cp3.vo.SubTitleElementVO;
import be.devine.cp3.vo.TitleElementVO;

import flash.events.Event;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

public class Page extends Sprite{

    private var pageVO:PageVO;
    private var _hasText:Boolean = false;
    private var _hasBackground:Boolean = false;
    private var appModel:AppModel;
    private var _background:Quad;
    private var _elementContainer:Sprite;
    private var pageNumberElement:PageNumberElement;
    private var marginLeft: int = 20;
    private var marginTop: int = 20;
    public var pagenumber:int;

    public function Page(pageVO:PageVO) {
        this.appModel = AppModel.getInstance();
        this.appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);
        this.pageVO = pageVO;
        this.pagenumber = pageVO.pageNumber;
        loadPage();
    }

    private function loadPage():void{
        _background = new Quad(910, 600);
        _background.x = (appModel.appwidth * 0.5) - (_background.width *.5);
        _background.y = (appModel.appheight * 0.5) - (_background.height *.5);
        _background.alpha = 0;
        _background.color = 0xedefef;
        addChild(_background);

        _elementContainer = new Sprite();
        _elementContainer.x = _background.x + marginLeft;
        _elementContainer.y = _background.y + marginTop;
        addChild(_elementContainer);

        for each(var elementVO:ElementVO in pageVO.elements){
            var element:Element = ElementViewFactory.createFromVO(elementVO);
            if(element != null){

                if(element is BackgroundPhotoElement){
                    _hasBackground = true;
                    element.addEventListener(starling.events.Event.COMPLETE, backgroundLoadedHandler);
                    addChildAt(element, 0);
                }

                if (element is TitleElement) {
                    element.x = (elementVO as TitleElementVO).xPos;
                    element.y = (elementVO as TitleElementVO).yPos;
                    // element.filter =
                    _elementContainer.addChild(element);
                }

                if (element is SubTitleElement) {
                    element.x = (_background.width>>1)-(element.width>>1) - marginLeft;
                    element.y = (elementVO as SubTitleElementVO).yPos;
                    _elementContainer.addChild(element);

                }

                if (element is IntroTextElement){
                    _hasText = true;
                    element.x = (elementVO as IntroTextElementVO).xPos;
                    element.y = (elementVO as IntroTextElementVO).yPos;
                    _elementContainer.addChild(element);

                }

                if (element is BodyTextElement) {
                    element.x = (elementVO as BodyTextElementVO).xPos;
                    element.y = (elementVO as BodyTextElementVO).yPos;
                    _elementContainer.addChild(element);

                }

                if (element is LinkElement) {
                    element.x = (elementVO as LinkElementVO).xPos;
                    element.y = (elementVO as LinkElementVO).yPos;
                    element.useHandCursor = true;
                    element.addEventListener(LinkElement.LINK_CLICKED, linkClickedHandler);
                    _elementContainer.addChild(element);

                }
            }
        }


        if(_hasText && _hasBackground){
            //TODO: quad opacity aanpassen
            _background.alpha = 0.7;
        }

        pageNumberElement = new PageNumberElement(pagenumber);
        pageNumberElement.x = (_background.width>>1)-(pageNumberElement.width>>1) - marginLeft;
        pageNumberElement.y = _background.height - pageNumberElement.height - 30 - marginTop;
        _elementContainer.addChild(pageNumberElement);

    }

    private function backgroundLoadedHandler(event:starling.events.Event):void {
        dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE, true));
    }

    public function get hasBackground():Boolean {
        return _hasBackground;
    }

    private function resizeHandler(event:flash.events.Event):void {
         pageNumberElement.x = (_background.width>>1)-(pageNumberElement.width>>1) - marginLeft;
         pageNumberElement.y = _background.height - pageNumberElement.height - 30 - marginTop;

         if(_background != null){
             _background.x = (appModel.appwidth * 0.5) - (_background.width *.5);
             _background.y = (appModel.appheight * 0.5) - (_background.height *.5);
         }

        if(_elementContainer != null){
            _elementContainer.x = _background.x + marginLeft;
            _elementContainer.y = _background.y + marginTop;
        }

    }

    private function linkClickedHandler(event:starling.events.Event):void {
        var linkelement:LinkElement = event.target as LinkElement;
        appModel.selectedPageIndex = linkelement.linkTo;
    }

}
}