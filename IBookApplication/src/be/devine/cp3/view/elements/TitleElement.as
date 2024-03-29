/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:56
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.config.Config;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.vo.TitleElementVO;

import starling.text.TextField;
import starling.utils.HAlign;

public class TitleElement extends Element{
    private var appModel:AppModel;

    public function TitleElement(titleElementVO:TitleElementVO) {
        super (titleElementVO);
        appModel = AppModel.getInstance();

        //DROPSHADOW
        //TODO: bestaat er een betere manier om dropshadow te creëren?
        var d:TextField = new TextField(900, 63, titleElementVO.title, Config.FONTBOLD , 46, 0xedefef, true);
        d.vAlign = "top";
        d.hAlign = HAlign.LEFT;
        d.x = -2;
        d.y = -2;
        addChild(d);

        //TITEL IN KLEUR
        var t:TextField = new TextField(900, 63, titleElementVO.title, Config.FONTBOLD , 46, appModel.selectedColorIndex, true);
        t.vAlign = "top";
        t.hAlign = HAlign.LEFT;
        //t.border = true;
        addChild(t);
    }
}
}
