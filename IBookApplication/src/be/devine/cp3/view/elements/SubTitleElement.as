package be.devine.cp3.view.elements {
import be.devine.cp3.style.Style;
import be.devine.cp3.vo.SubTitleElementVO;

import starling.text.TextField;

public class SubTitleElement extends Element{

    public function SubTitleElement(subTitleElementVO:SubTitleElementVO) {
        super (subTitleElementVO);
        var t:TextField = new TextField(500, 20, '- ' + subTitleElementVO.subtitle + ' -', Style.FONT , 12, 0X666666, true);
        t.vAlign = "top";
        //trace(t.textBounds);
        t.border = true;
        addChild(t);

    }
}
}
