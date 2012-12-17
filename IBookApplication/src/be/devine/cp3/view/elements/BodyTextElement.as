/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 14:52
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.config.Config;
import be.devine.cp3.vo.BodyTextElementVO;

import starling.text.TextField;
import starling.utils.HAlign;

public class BodyTextElement extends Element{
    public function BodyTextElement(bodyTextElementVO:BodyTextElementVO) {
        super(bodyTextElementVO);
        var t:TextField = new TextField(270, 400, bodyTextElementVO.text, Config.FONT , 12, 0x353535);
        t.vAlign = "top";
        t.hAlign = HAlign.LEFT;
        //t.border = true;
        addChild(t);
    }
}
}
