package {

import flash.display.Sprite;
import flash.text.TextField;

public class IBookApplication extends Sprite {
    public function IBookApplication() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);
    }
}
}
