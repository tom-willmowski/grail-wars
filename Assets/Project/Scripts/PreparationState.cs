using Bice.Code.States;
using Bice.GrailWars.View;
using UnityEngine;
using UniRx;
using System;
using Bice.GrailWars.Code.Systems;

namespace Bice.GrailWars.States
{
    [CreateAssetMenu(menuName = "Bice/State/Preparation")]
    public class PreparationState : GameState
    {
        [SerializeField]
        private GrailElement grailPrefab;
        [SerializeField]
        private Vector3 defaultGrailPosition;
        [SerializeField]
        private float examineDuration = 3;

        private FaderElement fader;
        private Camera topDownCamera;
        private GrailMapGenerator generator;

        private IDisposable handle;

        public override void Start()
        {
            Context.Get<ColorPaletteSystem>().UpdateFog(20);
            fader = GameObject.FindObjectOfType<FaderElement>();
            topDownCamera = GameObject.FindGameObjectWithTag("TopDownCamera").GetComponent<Camera>();
            topDownCamera.enabled = true;
            generator = GameObject.FindObjectOfType<GrailMapGenerator>();
            generator.Build();

            GrailElement grailInstance = Instantiate(grailPrefab, generator.GetRandomPosition(), Quaternion.identity);
            fader.Out(() => 
            {
                if(handle != null)
                {
                    handle.Dispose();
                }
                handle = Observable.Timer(TimeSpan.FromSeconds(examineDuration)).Subscribe((xs) => 
                {
                    Change<SeekState>().Setup(grailInstance);
                });
            });
        }

        public override void Stop()
        {
            topDownCamera.enabled = false;
            handle.Dispose();
        }
    }
}