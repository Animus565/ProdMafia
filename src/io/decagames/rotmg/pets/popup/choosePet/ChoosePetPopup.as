package io.decagames.rotmg.pets.popup.choosePet {
import flash.geom.Rectangle;

import io.decagames.rotmg.pets.components.petItem.PetItem;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.gird.UIGrid;
import io.decagames.rotmg.ui.gird.UIGridElement;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;

public class ChoosePetPopup extends ModalPopup {

    public static var POPUP_WIDTH:int = 440;

    public function ChoosePetPopup() {
        super(POPUP_WIDTH, 160, "Choose a Pet", DefaultLabelFormat.defaultSmallPopupTitle, new Rectangle(0, 0, POPUP_WIDTH, 220));
        this.petGrid = new UIGrid(POPUP_WIDTH - 40, 9, 5, contentHeight - 10, 5);
        this.petGrid.y = 10;
        this.petGrid.x = 10;
        addChild(this.petGrid);
    }

    private var petGrid:UIGrid;

    public function addPet(param1:PetItem):void {
        var _loc2_:UIGridElement = new UIGridElement();
        _loc2_.addChild(param1);
        this.petGrid.addGridElement(_loc2_);
    }
}
}
