/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 14:52
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.vo.BodyTextElementVO;

import starling.text.TextField;

public class BodyTextElement extends Element{
    public function BodyTextElement(bodyTextElementVO:BodyTextElementVO) {
        super(bodyTextElementVO);
        var t:TextField = new TextField(350, 700, bodyTextElementVO.text, "Arial" , 12, 0x353535);
        t.vAlign = "top";
        t.border = true;
        addChild(t);
    }
}
}
