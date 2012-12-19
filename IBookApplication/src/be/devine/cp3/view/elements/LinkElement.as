/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 16:00
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.config.Config;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.vo.LinkElementVO;

import flash.events.Event;

import starling.display.DisplayObject;

import starling.events.Event;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class LinkElement extends Element {

    private var appModel:AppModel;
    public static const LINK_CLICKED:String = "linkElement";
    private var _linkTo:uint;

    public function LinkElement(linkElementVO:LinkElementVO) {
        super (linkElementVO);

        appModel = AppModel.getInstance();
        var t:TextField = new TextField(270, 20, linkElementVO.text, Config.FONT , 12, appModel.selectedColorIndex, true);
        t.vAlign = VAlign.TOP;
        t.hAlign = HAlign.LEFT;
        t.underline = true;
        //t.border = true;
        _linkTo = linkElementVO.linkTo;
        addChild(t);


        addEventListener(TouchEvent.TOUCH, touchHandler);
    }

    private function touchHandler(event:TouchEvent):void {

        if(event.getTouch(event.target as DisplayObject, TouchPhase.BEGAN)) {
            dispatchEvent(new starling.events.Event(LINK_CLICKED));
        }
    }

    public function get linkTo():uint {
        return _linkTo;
    }
}
}
