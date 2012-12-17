package be.devine.cp3.view.elements {
import be.devine.cp3.config.Config;
import be.devine.cp3.vo.SubTitleElementVO;

import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class SubTitleElement extends Element{

    public function SubTitleElement(subTitleElementVO:SubTitleElementVO) {
        super (subTitleElementVO);
        var t:TextField = new TextField(600, 20, '- ' + subTitleElementVO.subtitle + ' -', Config.FONT , 12, 0X666666, true);
        t.vAlign = VAlign.TOP;
        t.hAlign = HAlign.CENTER;
        //trace(t.textBounds);
        //t.border = true;
        addChild(t);

    }
}
}
