/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 14:34
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.style.Style;

import starling.display.Quad;
import starling.display.Sprite;

public class ThumbnailContainer extends Sprite {
    private var background:Quad;
    public function ThumbnailContainer() {
        background = new Quad(AppModel.instance.appwidth, AppModel.instance.appheight, Style.TIMELINECOLOR);
        background.alpha = 0.82;
        addChild(background);
    }
}
}
