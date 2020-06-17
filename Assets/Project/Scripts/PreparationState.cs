using Bice.Code.States;
using Bice.GrailWars.View;
using UnityEngine; 

namespace Bice.GrailWars.States
{
    [CreateAssetMenu(menuName = "Bice/State/Preparation")]
    public class PreparationState : GameState
    {
        private FaderElement fader;
        private Camera topDownCamera;
        private GrailMapGenerator generator;

        public override void Start()
        {
            fader = GameObject.FindObjectOfType<FaderElement>();
            topDownCamera = GameObject.FindGameObjectWithTag("TopDownCamera").GetComponent<Camera>();
            topDownCamera.enabled = true;
            generator = GameObject.FindObjectOfType<GrailMapGenerator>();
            generator.Build();
            fader.Out(() => { StateMachine.Change<SeekState>(); });
        }

        public override void Stop()
        {
            topDownCamera.enabled = false;
        }
    }
}