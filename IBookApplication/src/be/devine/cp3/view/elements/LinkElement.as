/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 16:00
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.vo.LinkElementVO;

import starling.text.TextField;

public class LinkElement extends Element {
    //TODO:Thomas: linkelement opmaken CHECK
    public function LinkElement(linkElementVO:LinkElementVO) {
        super (linkElementVO);
        var t:TextField = new TextField(350, 20, linkElementVO.text, "Arial" , 72, linkElementVO.color, true);
        t.vAlign = "top";
        //trace(t.textBounds);
        t.border = true;
        addChild(t);
    }
}
}
