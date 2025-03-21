/**
 * VERSION: 1.896
 * DATE: 2012-01-06
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/loadermax/
 **/
package com.greensock.loading.display {
import com.greensock.loading.core.LoaderItem;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.media.Video;

/**
 * A container for visual content that is loaded by any of the following: ImageLoaders, SWFLoaders,
 * or VideoLoaders which is to be used in Flex. It is essentially a UIComponent that has a <code>loader</code>
 * property for easily referencing the original loader, as well as several other useful properties for
 * controling the placement of <code>rawContent</code> and the way it is scaled to fit (if at all). That way,
 * you can add a FlexContentDisplay to the display list or populate an array with as many as you want and then if
 * you ever need to unload() the content or reload it or figure out its url, etc., you can reference your
 * FlexContentDisplay's <code>loader</code> property like <code>myContent.loader.url</code> or
 * <code>(myContent.loader as SWFLoader).getClass("com.greensock.TweenLite");</code>.
 *
 *
 * <p><strong>IMPORTANT</strong>: In order for the LoaderMax loaders to use FlexContentDisplay instead of
 * the regular ContentDisplay class, you must set the <code>LoaderMax.contentDisplayClass</code> property
 * to FlexContentDisplay once like:</p>
 * <listing version="3.0">
 import com.greensock.loading.~~;
 import com.greensock.loading.display.~~;

 LoaderMax.contentDisplayClass = FlexContentDisplay;
 </listing>
 *
 * <p>After that, all ImageLoaders, SWFLoaders, and VideoLoaders will return FlexContentDisplay objects
 * as their <code>content</code> instead of regular ContentDisplay objects. </p>
 *
 * <p><strong>Copyright 2009-2014, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 *
 * @author Jack Doyle, jack@greensock.com
 */
public class FlexContentDisplay extends UIComponent {
    /** @private **/
    protected static var _transformProps:Object = {
        x: 1,
        y: 1,
        z: 1,
        rotationX: 1,
        rotationY: 1,
        rotationZ: 1,
        scaleX: 1,
        scaleY: 1,
        rotation: 1,
        alpha: 1,
        visible: true,
        blendMode: "normal",
        centerRegistration: false,
        crop: false,
        scaleMode: "stretch",
        hAlign: "center",
        vAlign: "center"
    };

    /**
     * Constructor
     *
     * @param loader The Loader object that will populate the FlexContentDisplay's <code>rawContent</code>.
     */
    public function FlexContentDisplay(loader:LoaderItem) {
        super();
        this.loader = loader;
    }

    /** @private A place to reference an object that should be protected from gc - this is used in VideoLoader in order to protect the NetStream object when the loader is disposed. **/
    public var gcProtect:*;
    /** Arbitrary data that you can associate with the FlexContentDisplay instance. For example, you could set <code>data</code> to be an object containing various other properties or set it to an index number related to an array in your application. It is completely optional and arbitrary. **/
    public var data:*;
    /** @private only used when crop is true - works around bugs in Flash with the way it reports getBounds() on objects with a scrollRect. **/
    protected var _cropContainer:Sprite;
    /** @private Primarily for Video objects which don't act like anything else - we must store the original width/height ratio in this variable so that we can properly apply scaleModes **/
    protected var _nativeRect:Rectangle;

    /** @private **/
    protected var _loader:LoaderItem;

    /** The loader whose rawContent populates this FlexContentDisplay. If you get the loader's <code>content</code>, it will return this FlexContentDisplay object. **/
    public function get loader():LoaderItem {
        return _loader;
    }

    public function set loader(value:LoaderItem):void {
        _loader = value;
        if (value == null) {
            return;
        } else if (!_loader.hasOwnProperty("setContentDisplay")) {
            throw new Error("Incompatible loader used for a FlexContentDisplay");
        }
        this.name = _loader.name;
        var type:String;
        for (var p:String in _transformProps) {
            if (p in _loader.vars) {
                type = typeof (_transformProps[p]);
                this[p] = (type == "number") ? Number(_loader.vars[p]) : (type == "string") ? String(_loader.vars[p]) : Boolean(_loader.vars[p]);
            }
        }
        _bgColor = uint(_loader.vars.bgColor);
        _bgAlpha = ("bgAlpha" in _loader.vars) ? Number(_loader.vars.bgAlpha) : ("bgColor" in _loader.vars) ? 1 : 0;
        _fitWidth = ("fitWidth" in _loader.vars) ? Number(_loader.vars.fitWidth) : Number(_loader.vars.width);
        _fitHeight = ("fitHeight" in _loader.vars) ? Number(_loader.vars.fitHeight) : Number(_loader.vars.height);
        _update();
        if (_loader.vars.container is DisplayObjectContainer) {
            if (_loader.vars.container.hasOwnProperty("addElement")) {
                (_loader.vars.container as Object).addElement(this);
            } else {
                (_loader.vars.container as DisplayObjectContainer).addChild(this);
            }
        }
        if (_loader.content != this) {
            (_loader as Object).setContentDisplay(this);
        }
        this.rawContent = (_loader as Object).rawContent;
    }

    /** @private **/
    protected var _rawContent:DisplayObject;

    /** The raw content which can be a Bitmap, a MovieClip, a Loader, or a Video depending on the type of loader associated with the FlexContentDisplay. **/
    public function get rawContent():* {
        return _rawContent;
    }

    public function set rawContent(value:*):void {
        if (_rawContent != null && _rawContent != value) {
            if (_rawContent.parent == this) {
                removeChild(_rawContent);
            } else if (_cropContainer != null && _rawContent.parent == _cropContainer) {
                _cropContainer.removeChild(_rawContent);
                removeChild(_cropContainer);
                _cropContainer = null;
            }
        }
        _rawContent = value as DisplayObject;
        if (_rawContent == null) {
            return;
        } else if (_rawContent.parent == null || (_rawContent.parent != this && _rawContent.parent != _cropContainer)) {
            addChildAt(_rawContent as DisplayObject, 0);
        }
        _nativeRect = new Rectangle(0, 0, _rawContent.width, _rawContent.height);
        _update();
    }

    /** @private **/
    protected var _centerRegistration:Boolean;

    /**
     * If <code>true</code>, the FlexContentDisplay's registration point will be placed in the center of the <code>rawContent</code>
     * which can be useful if, for example, you want to animate its scale and have it grow/shrink from its center.
     * @see #scaleMode
     **/
    public function get centerRegistration():Boolean {
        return _centerRegistration;
    }

    public function set centerRegistration(value:Boolean):void {
        _centerRegistration = value;
        _update();
    }

    /** @private **/
    protected var _crop:Boolean;

    /**
     * When the FlexContentDisplay's <code>fitWidth</code> and <code>fitHeight</code> properties are defined (or <code>width</code>
     * and <code>height</code> in the loader's <code>vars</code> property/parameter), setting <code>crop</code> to
     * <code>true</code> will cause the <code>rawContent</code> to be cropped within that area (by applying a <code>scrollRect</code>
     * for maximum performance). This is typically useful when the <code>scaleMode</code> is <code>"proportionalOutside"</code>
     * or <code>"none"</code> so that any parts of the <code>rawContent</code> that exceed the dimensions defined by
     * <code>fitWidth</code> and <code>fitHeight</code> are visually chopped off. Use the <code>hAlign</code> and
     * <code>vAlign</code> properties to control the vertical and horizontal alignment within the cropped area.
     *
     * @see #scaleMode
     **/
    public function get crop():Boolean {
        return _crop;
    }

    public function set crop(value:Boolean):void {
        _crop = value;
        _update();
    }

    /** @private **/
    protected var _scaleMode:String = "stretch";

    /**
     * When the FlexContentDisplay's <code>fitWidth</code> and <code>fitHeight</code> properties are defined (or <code>width</code>
     * and <code>height</code> in the loader's <code>vars</code> property/parameter), the <code>scaleMode</code> controls how
     * the <code>rawContent</code> will be scaled to fit the area. The following values are recognized (you may use the
     * <code>com.greensock.layout.ScaleMode</code> constants if you prefer):
     * <ul>
     *        <li><code>"stretch"</code> (the default) - The <code>rawContent</code> will fill the width/height exactly.</li>
     *        <li><code>"proportionalInside"</code> - The <code>rawContent</code> will be scaled proportionally to fit inside the area defined by the width/height</li>
     *        <li><code>"proportionalOutside"</code> - The <code>rawContent</code> will be scaled proportionally to completely fill the area, allowing portions of it to exceed the bounds defined by the width/height.</li>
     *        <li><code>"widthOnly"</code> - Only the width of the <code>rawContent</code> will be adjusted to fit.</li>
     *        <li><code>"heightOnly"</code> - Only the height of the <code>rawContent</code> will be adjusted to fit.</li>
     *        <li><code>"none"</code> - No scaling of the <code>rawContent</code> will occur.</li>
     * </ul>
     **/
    public function get scaleMode():String {
        return _scaleMode;
    }

//---- GETTERS / SETTERS -------------------------------------------------------------------------

    public function set scaleMode(value:String):void {
        if (_rawContent != null) {
            _rawContent.scaleX = _rawContent.scaleY = 1;
        }
        _scaleMode = value;
        _update();
    }

    /** @private **/
    protected var _hAlign:String = "center";

    /**
     * When the FlexContentDisplay's <code>fitWidth</code> and <code>fitHeight</code> properties are defined (or <code>width</code>
     * and <code>height</code> in the loader's <code>vars</code> property/parameter), the <code>hAlign</code> determines how
     * the <code>rawContent</code> is horizontally aligned within that area. The following values are recognized (you may use the
     * <code>com.greensock.layout.AlignMode</code> constants if you prefer):
     * <ul>
     *        <li><code>"center"</code> (the default) - The <code>rawContent</code> will be centered horizontally in the FlexContentDisplay</li>
     *        <li><code>"left"</code> - The <code>rawContent</code> will be aligned with the left side of the FlexContentDisplay</li>
     *        <li><code>"right"</code> - The <code>rawContent</code> will be aligned with the right side of the FlexContentDisplay</li>
     * </ul>
     * @see #scaleMode
     * @see #vAlign
     **/
    public function get hAlign():String {
        return _hAlign;
    }

    public function set hAlign(value:String):void {
        _hAlign = value;
        _update();
    }

    /** @private **/
    protected var _vAlign:String = "center";

    /**
     * When the FlexContentDisplay's <code>fitWidth</code> and <code>fitHeight</code> properties are defined (or <code>width</code>
     * and <code>height</code> in the loader's <code>vars</code> property/parameter), the <code>vAlign</code> determines how
     * the <code>rawContent</code> is vertically aligned within that area. The following values are recognized (you may use the
     * <code>com.greensock.layout.AlignMode</code> constants if you prefer):
     * <ul>
     *        <li><code>"center"</code> (the default) - The <code>rawContent</code> will be centered vertically in the FlexContentDisplay</li>
     *        <li><code>"top"</code> - The <code>rawContent</code> will be aligned with the top of the FlexContentDisplay</li>
     *        <li><code>"bottom"</code> - The <code>rawContent</code> will be aligned with the bottom of the FlexContentDisplay</li>
     * </ul>
     * @see #scaleMode
     * @see #hAlign
     **/
    public function get vAlign():String {
        return _vAlign;
    }

    public function set vAlign(value:String):void {
        _vAlign = value;
        _update();
    }

    /** @private **/
    protected var _bgColor:uint;

    /**
     * When the FlexContentDisplay's <code>fitWidth</code> and <code>fitHeight</code> properties are defined (or <code>width</code>
     * and <code>height</code> in the loader's <code>vars</code> property/parameter), a rectangle will be drawn inside the
     * FlexContentDisplay object immediately in order to ease the development process (for example, you can add <code>ROLL_OVER/ROLL_OUT</code>
     * event listeners immediately). It is transparent by default, but you may define a <code>bgAlpha</code> if you prefer.
     * @see #bgAlpha
     * @see #fitWidth
     * @see #fitHeight
     **/
    public function get bgColor():uint {
        return _bgColor;
    }

    public function set bgColor(value:uint):void {
        _bgColor = value;
        _update();
    }

    /** @private **/
    protected var _bgAlpha:Number = 0;

    /**
     * Controls the alpha of the rectangle that is drawn when the FlexContentDisplay's <code>fitWidth</code> and <code>fitHeight</code>
     * properties are defined (or <code>width</code> and <code>height</code> in the loader's <code>vars</code> property/parameter).
     * @see #bgColor
     * @see #fitWidth
     * @see #fitHeight
     **/
    public function get bgAlpha():Number {
        return _bgAlpha;
    }

    public function set bgAlpha(value:Number):void {
        _bgAlpha = value;
        _update();
    }

    /** @private **/
    protected var _fitWidth:Number;

    /**
     * The width to which the <code>rawContent</code> should be fit according to the FlexContentDisplay's <code>scaleMode</code>
     * (this width is figured before rotation, scaleX, and scaleY). When a "width" property is defined in the loader's <code>vars</code>
     * property/parameter, it is automatically applied to this <code>fitWidth</code> property. For example, the following code will
     * set the loader's FlexContentDisplay <code>fitWidth</code> to 100:<p><code>
     *
     * var loader:ImageLoader = new ImageLoader("photo.jpg", {width:100, height:80, container:this});</code></p>
     *
     * @see #fitHeight
     * @see #scaleMode
     **/
    public function get fitWidth():Number {
        return _fitWidth;
    }

    public function set fitWidth(value:Number):void {
        _fitWidth = value;
        _update();
    }

    /** @private **/
    protected var _fitHeight:Number;

    /**
     * The height to which the <code>rawContent</code> should be fit according to the FlexContentDisplay's <code>scaleMode</code>
     * (this height is figured before rotation, scaleX, and scaleY). When a "height" property is defined in the loader's <code>vars</code>
     * property/parameter, it is automatically applied to this <code>fitHeight</code> property. For example, the following code will
     * set the loader's FlexContentDisplay <code>fitHeight</code> to 80:<p><code>
     *
     * var loader:ImageLoader = new ImageLoader("photo.jpg", {width:100, height:80, container:this});</code></p>
     *
     * @see #fitWidth
     * @see #scaleMode
     **/
    public function get fitHeight():Number {
        return _fitHeight;
    }

    public function set fitHeight(value:Number):void {
        _fitHeight = value;
        _update();
    }

    /** @private **/
    override protected function measure():void {
        var bounds:Rectangle;
        if (this.parent) {
            bounds = this.getBounds(this.parent);
            this.width = bounds.width;
            this.height = bounds.height;
        }
        bounds = this.getBounds(this);
        this.explicitWidth = bounds.width;
        this.explicitHeight = bounds.height;
        super.measure();
    }

    /**
     * Removes the FlexContentDisplay from the display list (if necessary), dumps the <code>rawContent</code>,
     * and calls <code>unload()</code> and <code>dispose()</code> on the loader (unless you define otherwise with
     * the optional parameters). This essentially destroys the FlexContentDisplay and makes it eligible for garbage
     * collection internally, although if you added any listeners manually, you should remove them as well.
     *
     * @param unloadLoader If <code>true</code>, <code>unload()</code> will be called on the loader. It is <code>true</code> by default.
     * @param disposeLoader If <code>true</code>, <code>dispose()</code> will be called on the loader. It is <code>true</code> by default.
     */
    public function dispose(unloadLoader:Boolean = true, disposeLoader:Boolean = true):void {
        if (this.parent != null) {
            if (this.parent.hasOwnProperty("removeElement")) {
                (this.parent as Object).removeElement(this);
            } else {
                this.parent.removeChild(this);
            }
        }
        this.rawContent = null;
        this.gcProtect = null;
        _cropContainer = null;
        if (_loader != null) {
            if (unloadLoader) {
                _loader.unload();
            }
            if (disposeLoader) {
                _loader.dispose(false);
                _loader = null;
            }
        }
    }

    /** @private **/
    protected function _update():void {
        var left:Number = (_centerRegistration && _fitWidth > 0) ? _fitWidth / -2 : 0;
        var top:Number = (_centerRegistration && _fitHeight > 0) ? _fitHeight / -2 : 0;
        graphics.clear();
        if (_fitWidth > 0 && _fitHeight > 0) {
            graphics.beginFill(_bgColor, _bgAlpha);
            graphics.drawRect(left, top, _fitWidth, _fitHeight);
            graphics.endFill();
        }
        if (_rawContent == null) {
            measure();
            return;
        }
        var mc:DisplayObject = _rawContent;
        var m:Matrix = mc.transform.matrix;
        var nativeBounds:Object, contentWidth:Number, contentHeight:Number;
        if (mc is Video) {//Video objects don't accurately report getBounds() - they act like their native dimension is always 160x320.
            nativeBounds = _nativeRect;
            contentWidth = mc.width;
            contentHeight = mc.height;
        } else {
            if (mc is Loader) {
                nativeBounds = Loader(mc).contentLoaderInfo;
            } else if (_loader != null && _loader.hasOwnProperty("getClass")) {
                nativeBounds = mc.loaderInfo; //for SWFLoaders, use loaderInfo.width/height so that everything is based on the stage size, not the bounding box of the DisplayObjects that happen to be on the stage (which could be much larger or smaller than the swf's stage)
            } else {
                nativeBounds = mc.getBounds(mc);
            }
            if (nativeBounds is LoaderInfo && _loader != null && _loader.progress < 1) {
                try {
                    contentWidth = nativeBounds.width; //if not enough of the file has loaded, this can throw a runtime error saying that the "width" isn't known yet.
                } catch (error:Error) {
                    nativeBounds = mc.getBounds(mc);
                }
            }
            contentWidth = nativeBounds.width * Math.abs(m.a) + nativeBounds.height * Math.abs(m.b);
            contentHeight = nativeBounds.width * Math.abs(m.c) + nativeBounds.height * Math.abs(m.d);
        }

        if (_fitWidth > 0 && _fitHeight > 0) {
            var w:Number = _fitWidth;
            var h:Number = _fitHeight;

            var wGap:Number = w - contentWidth;
            var hGap:Number = h - contentHeight;

            if (_scaleMode != "none") {
                var displayRatio:Number = w / h;
                var contentRatio:Number = nativeBounds.width / nativeBounds.height;
                if ((contentRatio < displayRatio && _scaleMode == "proportionalInside") || (contentRatio > displayRatio && _scaleMode == "proportionalOutside")) {
                    w = h * contentRatio;
                }
                if ((contentRatio > displayRatio && _scaleMode == "proportionalInside") || (contentRatio < displayRatio && _scaleMode == "proportionalOutside")) {
                    h = w / contentRatio;
                }

                if (_scaleMode != "heightOnly") {
                    mc.width *= w / contentWidth;
                    wGap = _fitWidth - w;
                }
                if (_scaleMode != "widthOnly") {
                    mc.height *= h / contentHeight;
                    hGap = _fitHeight - h;
                }
            }

            if (_hAlign == "left") {
                wGap = 0;
            } else if (_hAlign != "right") {
                wGap /= 2;
            }
            if (_vAlign == "top") {
                hGap = 0;
            } else if (_vAlign != "bottom") {
                hGap /= 2;
            }

            if (_crop) {
                //due to bugs in the way Flash reports getBounds() on objects with a scrollRect, we need to just wrap the rawContent in a container and apply the scrollRect to the container.
                if (_cropContainer == null || mc.parent != _cropContainer) {
                    _cropContainer = new Sprite();
                    this.addChildAt(_cropContainer, this.getChildIndex(mc));
                    _cropContainer.addChild(mc);
                }
                _cropContainer.x = left;
                _cropContainer.y = top;
                _cropContainer.scrollRect = new Rectangle(0, 0, _fitWidth, _fitHeight);
                mc.x = wGap;
                mc.y = hGap;
            } else {
                if (_cropContainer != null) {
                    this.addChildAt(mc, this.getChildIndex(_cropContainer));
                    _cropContainer = null;
                }
                mc.x = left + wGap;
                mc.y = top + hGap;
            }

        } else {
            mc.x = (_centerRegistration) ? contentWidth / -2 : 0;
            mc.y = (_centerRegistration) ? contentHeight / -2 : 0;
        }
        measure();
    }
}
}