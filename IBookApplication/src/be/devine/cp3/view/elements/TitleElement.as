/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:56
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.style.Style;
import be.devine.cp3.vo.TitleElementVO;

import starling.text.TextField;
import starling.utils.HAlign;


public class TitleElement extends Element{
    private var appModel:AppModel;

    public function TitleElement(titleElementVO:TitleElementVO) {
        super (titleElementVO);
        appModel = AppModel.getInstance();
        var t:TextField = new TextField(900, 63, titleElementVO.title, Style.FONTBOLD , 46, appModel.selectedColorIndex, true);
        t.vAlign = "top";
        t.hAlign = HAlign.LEFT;
        //t.border = true;
        addChild(t);
    }
}
}
