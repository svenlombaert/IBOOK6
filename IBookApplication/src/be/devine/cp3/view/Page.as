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
import be.devine.cp3.view.elements.TitleElement;
import be.devine.cp3.vo.ElementVO;
import be.devine.cp3.vo.PageVO;

import starling.core.Starling;
import starling.display.Sprite;

public class Page extends Sprite{

    private var pageVO:PageVO;
    private var _hasText:Boolean = false;
    private var _hasIntro:Boolean = false;
    private var _hasBackground:Boolean = false;
    private var _hasTitle:Boolean = false;
    private var appModel:AppModel;
    private var _container:Sprite;
    public var pagenumber:int;

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

        for each(var elementVO:ElementVO in pageVO.elements){
            var element:Element = ElementViewFactory.createFromVO(elementVO);
            if(element != null){
                trace('[PAGE]' + element);
                _container = new Sprite();
                _container.width = 900;
                _container.height = 600;

                addChild(_container);
                if (element is TitleElement) {
                    _hasTitle = true;
                    //element = title;
                }

                if (element is IntroTextElement){
                    //plaats vanboven
                    _hasIntro = true;

                    element.y = 100;
                    //element = intro;
                }

                if (element is BodyTextElement) {
                    element.x = 300;

                    element.y = 100;
                }
                if(element is BackgroundPhotoElement){
                    _hasBackground = true;
                    //element = photo;
                }


                _container.addChild(element);
            }
        }
        if(_hasText && _hasBackground){
            //TODO: quad maken en addChilden
        }

    }
}
}