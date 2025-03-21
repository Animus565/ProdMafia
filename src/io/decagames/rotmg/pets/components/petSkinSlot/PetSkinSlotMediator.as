package io.decagames.rotmg.pets.components.petSkinSlot {
import flash.events.MouseEvent;

import io.decagames.rotmg.pets.components.petIcon.PetIconFactory;
import io.decagames.rotmg.pets.data.vo.IPetVO;
import io.decagames.rotmg.pets.signals.SelectPetSkinSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class PetSkinSlotMediator extends Mediator {

    public function PetSkinSlotMediator() {
        super();
    }

    [Inject]
    public var view:PetSkinSlot;
    [Inject]
    public var petIconFactory:PetIconFactory;
    [Inject]
    public var selectPetSkin:SelectPetSkinSignal;

    override public function initialize():void {
        if (this.view.skinVO) {
            this.view.addSkin(this.petIconFactory.getPetSkinTexture(this.view.skinVO, 40, this.view.skinVO.rarity.color));
        }
        if (this.view.isSkinSelectableSlot) {
            if (this.view.skinVO.isOwned) {
                this.view.addEventListener("click", this.onSelectSkin);
            }
            this.selectPetSkin.add(this.onSkinSelected);
        }
        this.view.updatedVOSignal.add(this.onPetUpdated);
    }

    override public function destroy():void {
        if (this.view.isSkinSelectableSlot) {
            this.view.removeEventListener("click", this.onSelectSkin);
            this.selectPetSkin.remove(this.onSkinSelected);
        }
        this.view.updatedVOSignal.remove(this.onPetUpdated);
    }

    private function onPetUpdated():void {
        if (!this.view.manualUpdate) {
            this.view.addSkin(this.view.skinVO == null ? null : this.petIconFactory.getPetSkinTexture(this.view.skinVO, 40));
        }
    }

    private function onSkinSelected(param1:IPetVO):void {
        this.view.selected = param1.skinType == this.view.skinVO.skinType;
    }

    private function onSelectSkin(param1:MouseEvent):void {
        this.view.skinVO.isNew = false;
        this.view.clearNewLabel();
        this.selectPetSkin.dispatch(this.view.skinVO);
    }
}
}
