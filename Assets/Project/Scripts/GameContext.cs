using Bice.Code.Systems;
using Bice.GrailWars.States;
using UnityEngine;

namespace Bice.GrailWars
{
    [CreateAssetMenu(menuName = "Bice/System/GameContext")]
    public class GameContext : Context
    {
        public override void Resume()
        {
            base.Resume();
            Get<GameStateMachine>().Change<PreparationState>();
        }
    }
}
