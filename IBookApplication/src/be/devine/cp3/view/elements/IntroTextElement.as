/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 16:00
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.vo.IntroTextElementVO;

import starling.text.TextField;

public class IntroTextElement extends Element{
    //TODO: Thomas: intro text opmaken. CHECK
    public function IntroTextElement(introTextElementVO:IntroTextElementVO) {
        super(introTextElementVO);
        var t:TextField = new TextField(350, 700, introTextElementVO.text, "Arial" , 12, 0x353535, true);
        t.vAlign = "top";
        t.border = true;
        addChild(t);
    }
}
}
