package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles {
import robotlegs.bender.bundles.mvcs.Mediator;

public class ItemTileSpriteMediator extends Mediator {

    public function ItemTileSpriteMediator() {
        super();
    }

    [Inject]
    public var view:ItemTileSprite;

    override public function initialize():void {
        this.view.drawTile();
    }
}
}
