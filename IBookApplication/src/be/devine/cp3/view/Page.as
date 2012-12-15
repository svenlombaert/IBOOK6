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
    private var pageNumberElement:PageNumberElement;
    private var marginLeft: int = 20;
    private var marginTop: int = 20;

    public var pagenumber:int;

    public function Page(pageVO:PageVO) {
        this.appModel = AppModel.getInstance();
        this.pageVO = pageVO;
        //paginanummer halen uit de pageVO, dit paginanummer is nodig voor de klik functie in de thumbnail die gebruikt maakt van een 'Page' object
        this.pagenumber = pageVO.pageNumber;

        _background = new Quad(910, 650);
        _background.x = (appModel.appwidth * 0.5) - (_background.width *.5);
        _background.y = (appModel.appheight * 0.5) - (_background.height *.5);
        addChild(_background);

        _elementContainer = new Sprite();
        _elementContainer.x = _background.x + marginLeft;
        _elementContainer.y = _background.y + marginTop;
        addChild(_elementContainer);

        for each(var elementVO:ElementVO in pageVO.elements){
            var element:Element = ElementViewFactory.createFromVO(elementVO);
            if(element != null){
                if (element is TitleElement) {
                    _hasTitle = true;
                }

                if (element is SubTitleElement) {
                   element.x = (_background.width>>1)-(element.width>>1) - marginLeft;
                }

                if (element is IntroTextElement){
                    _hasIntro = true;
                    element.y = 100;
                }

                if (element is BodyTextElement) {
                    element.x = (elementVO as BodyTextElementVO).xPos;
                    element.y = (elementVO as BodyTextElementVO).yPos;
                }

                if(element is BackgroundPhotoElement){
                    _hasBackground = true;
                }

                if (element is LinkElement) {

                }
                _elementContainer.addChild(element);
            }
        }
        if(_hasText && _hasBackground){
            //TODO: quad opacity aanpassen
        }

        pageNumberElement = new PageNumberElement(pagenumber);
        pageNumberElement.x = (_background.width>>1)-(pageNumberElement.width>>1) - marginLeft;
        pageNumberElement.y = _background.height - pageNumberElement.height - 30 - marginTop;
        _elementContainer.addChild(pageNumberElement);
    }
}
}