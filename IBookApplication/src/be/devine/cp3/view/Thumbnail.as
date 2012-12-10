/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 10/12/12
 * Time: 10:53
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view {

import be.devine.cp3.style.Style;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.RenderTexture;

public class Thumbnail extends Sprite{
    private const maxWidth:uint = 220;
    private const maxHeight:uint = 140;

    public function Thumbnail(page:Page) {
        page.width = maxWidth;
        page.scaleY = page.scaleX;

        if(page.height > maxHeight){
           page.height = maxHeight;
           page.scaleX = page.scaleY;
        }
        var q:Quad = new Quad(220, 140, Style.PAGEBACKGROUNDCOLOR);
        var texture = new RenderTexture(q.width, q.height);
        texture.draw(q);
        texture.draw(page);
        var img:Image = new Image(texture);
        addChild(img);
        flatten();
    }
}
}
