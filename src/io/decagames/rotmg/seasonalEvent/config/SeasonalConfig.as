package io.decagames.rotmg.seasonalEvent.config {
import io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard.SeasonalItemDataFactory;
import io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard.SeasonalLeaderBoard;
import io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard.SeasonalLeaderBoardMediator;
import io.decagames.rotmg.seasonalEvent.buttons.SeasonalInfoButton;
import io.decagames.rotmg.seasonalEvent.buttons.SeasonalInfoButtonMediator;
import io.decagames.rotmg.seasonalEvent.commands.RequestChallengerListCommand;
import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventInfoPopup;
import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventInfoPopupMediator;
import io.decagames.rotmg.seasonalEvent.signals.RequestChallengerListSignal;
import io.decagames.rotmg.seasonalEvent.signals.SeasonalLeaderBoardErrorSignal;
import io.decagames.rotmg.seasonalEvent.signals.ShowSeasonHasEndedPopupSignal;

import org.swiftsuspenders.Injector;

import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
import robotlegs.bender.framework.api.IConfig;

public class SeasonalConfig implements IConfig {

    public function SeasonalConfig() {
        super();
    }

    [Inject]
    public var injector:Injector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var commandMap:ISignalCommandMap;

    public function configure():void {
        this.injector.map(SeasonalLeaderBoardErrorSignal).asSingleton();
        this.injector.map(ShowSeasonHasEndedPopupSignal).asSingleton();
        this.injector.map(SeasonalItemDataFactory).asSingleton();
        this.mediatorMap.map(SeasonalLeaderBoard).toMediator(SeasonalLeaderBoardMediator);
        this.mediatorMap.map(SeasonalEventInfoPopup).toMediator(SeasonalEventInfoPopupMediator);
        this.mediatorMap.map(SeasonalInfoButton).toMediator(SeasonalInfoButtonMediator);
        this.commandMap.map(RequestChallengerListSignal).toCommand(RequestChallengerListCommand);
    }
}
}
