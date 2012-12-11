/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 10/12/12
 * Time: 10:53
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.parts {
import be.devine.cp3.view.*;

import be.devine.cp3.style.Style;

import flash.events.Event;
import flash.filters.DisplacementMapFilter;

import starling.display.DisplayObject;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.RenderTexture;

public class Thumbnail extends Sprite{
    public static const MAXWIDTH:uint = 220;
    public static const MAXHEIGHT:uint = 140;

    //TODO: hover met paginanummer
    public function Thumbnail(page:Page) {
        page.width = MAXWIDTH;
        page.scaleY = page.scaleX;

        if(page.height > MAXHEIGHT){
           page.height = MAXHEIGHT;
           page.scaleX = page.scaleY;
        }
        var q:Quad = new Quad(220, 140, Style.THUMBNAILBACKGROUNDCOLOR);
        var texture = new RenderTexture(q.width, q.height);
        texture.draw(q);
        texture.draw(page);
        var img:Image = new Image(texture);
        img.alpha = 0.7;
        addChild(img);
        flatten();
    }

}
}
