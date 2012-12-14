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
import be.devine.cp3.view.elements.TitleElement;
import be.devine.cp3.vo.ElementVO;
import be.devine.cp3.vo.PageVO;
import be.devine.cp3.vo.TitleElementVO;

import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;

public class Page extends Sprite{

    private var pageVO:PageVO;
    private var _hasText:Boolean = false;
    private var _hasIntro:Boolean = false;
    private var _hasBackground:Boolean = false;
    private var _hasTitle:Boolean = false;
    private var appModel:AppModel;
    private var _background:Quad;
    private var _elementContainer:Sprite;
    public var pagenumber:int;
    private var pageNumberElement:PageNumberElement;

    /*private var title:Element,
                intro:Element,
                body1:Element,
                body2:Element,
                body3:Element,
                photo:Element;*/

    public function Page(pageVO:PageVO) {
        this.appModel = AppModel.getInstance();
        this.pageVO = pageVO;
        //paginanummer halen uit de pageVO, dit paginanummer is nodig voor de klik functie in de thumbnail die gebruikt maakt van een 'Page' object
        this.pagenumber = pageVO.pageNumber;

        _background = new Quad(900, 700);
        _background.x = (appModel.appwidth * 0.5) - (_background.width *.5);
        _background.y = (appModel.appheight * 0.5) - (_background.height *.5);
        addChild(_background);

        _elementContainer = new Sprite();
        _elementContainer.x = _background.x + 20;
        _elementContainer.y = _background.y + 20;
        addChild(_elementContainer);

        for each(var elementVO:ElementVO in pageVO.elements){
            var element:Element = ElementViewFactory.createFromVO(elementVO);
            if(element != null){
                if (element is TitleElement) {
                    _hasTitle = true;
                    //element.x = (elementVO as TitleElementVO).
                    //element = title;
                }

                if (element is IntroTextElement){
                    //plaats vanboven
                    _hasIntro = true;

                    element.y = 100;
                    //element = intro;
                }

                if (element is BodyTextElement) {
                    //element.x = 300;
                    //element.y = 100;

                }
                if(element is BackgroundPhotoElement){
                    _hasBackground = true;
                    //element = photo;
                }
                if (element is LinkElement) {

                }
                _elementContainer.addChild(element);
            }
        }
        if(_hasText && _hasBackground){
            //TODO: quad maken en addChilden
        }


        pageNumberElement = new PageNumberElement(pagenumber);
        pageNumberElement.x = (_background.width/2)-(pageNumberElement.width/2);
        //trace(pageNumberElement.width);
        pageNumberElement.y = _background.y + _background.height - pageNumberElement.height -10;
        addChild(pageNumberElement);



    }
}
}