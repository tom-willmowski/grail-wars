using Bice.Code.States;
using UnityEngine;
using UniRx;
using System;
using Bice.GrailWars.View;
using Bice.GrailWars.Code.Systems;
using System.Collections.Generic;

namespace Bice.GrailWars.States
{
    [CreateAssetMenu(menuName = "Bice/State/End")]
    public class EndState : GameState
    {
        private IDisposable handle;
        private Camera topDownCamera;
        private Light light;
        private List<PlayerElement> players;

        public override void Start()
        {
            Context.Get<ColorPaletteSystem>().UpdateFog(20);

            if (handle != null)
            {
                handle.Dispose();
            }
            handle = Observable.Timer(TimeSpan.FromSeconds(10)).Subscribe((ms) => 
            {
                Change<PreparationState>();
            });
        }

        public void Setup(PlayerElement winner, List<PlayerElement> players)
        {
            // focus on winner, etc.
            this.players = players;
        }

        public override void Stop()
        {
            players.ForEach(p => p.gameObject.SetActive(false));
        }
    }
}