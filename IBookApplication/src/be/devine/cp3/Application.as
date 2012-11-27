/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3 {


import be.devine.cp3.model.AppModel;

import flash.events.Event;

import starling.display.Quad;

import starling.display.Sprite;


public class Application extends Sprite {

    private var appModel:AppModel;

    public function Application() {
        trace('MAIN GEADD');

        appModel = AppModel.getInstance();

    }
}
}
