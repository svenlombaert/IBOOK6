/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:00
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view {
import be.devine.cp3.factory.view.ElementViewFactory;
import be.devine.cp3.view.elements.BackgroundPhotoElement;
import be.devine.cp3.view.elements.Element;
import be.devine.cp3.view.elements.IntroTextElement;
import be.devine.cp3.vo.ElementVO;
import be.devine.cp3.vo.PageVO;


import starling.display.Sprite;

public class Page extends Sprite{

    private var pageVO:PageVO;
    private var _hasText:Boolean = false;
    private var _hasBackground:Boolean = false;

    public function Page(pageVO:PageVO) {
        this.pageVO = pageVO;

        for each(var elementVO:ElementVO in pageVO.elements){
            var element:Element = ElementViewFactory.createFromVO(elementVO);
            if(element != null){
                trace("zet elemet op pagina");
                if(element is IntroTextElement){
                    //plaats vanboven
                    element.x = 20;
                    element.y = 20;
                }
                if(element is BackgroundPhotoElement){
                    _hasBackground = true
                }
                addChild(element);
            }
        }
        if(_hasText && _hasBackground){
            //TODO: quad maken en addChilden
        }

    }
}
}
