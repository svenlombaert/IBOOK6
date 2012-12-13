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
import be.devine.cp3.view.elements.Element;
import be.devine.cp3.view.elements.IntroTextElement;
import be.devine.cp3.vo.ElementVO;
import be.devine.cp3.vo.PageVO;


import starling.display.Sprite;

public class Page extends Sprite{

    private var pageVO:PageVO;
    private var appModel:AppModel;
    public var pagenumber:int;

    public function Page(pageVO:PageVO) {
        this.appModel = AppModel.getInstance();
        this.pageVO = pageVO;
        //paginanummer halen uit de pageVO, dit paginanummer is nodig voor de klik functie in de thumbnail die gebruikt maakt van een 'Page' object
        this.pagenumber = pageVO.pageNumber;

        for each(var elementVO:ElementVO in pageVO.elements){
            var element:Element = ElementViewFactory.createFromVO(elementVO);
            if(element != null){
                trace("zet elemet op pagina");
                if(element is IntroTextElement){
                    //plaats vanboven
                    element.x = 20;
                    element.y = 20;
                }
                addChild(element);
            }
            //addChild(element);
        }
    }
}
}
