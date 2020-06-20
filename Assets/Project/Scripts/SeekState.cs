using Bice.Code.States;
using Bice.GrailWars.Code.Systems;
using Bice.GrailWars.View;
using System;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

namespace Bice.GrailWars.States
{
    [CreateAssetMenu(menuName = "Bice/State/Seek")]
    public class SeekState : GameState
    {
        public float fogDistance = 3;

        [SerializeField]
        private PlayerElement playerPrefab;
        [SerializeField]
        private Vector3 defaultPosition;
        [SerializeField]
        private List<Rect> viewportRects;

        private GrailElement grail;
        private IDisposable handle;
        private List<PlayerElement> players = new List<PlayerElement>();
        private GrailMapGenerator generator;

        public override void Start()
        {
            generator = GameObject.FindObjectOfType<GrailMapGenerator>();
            Context.Get<ColorPaletteSystem>().UpdateFog(fogDistance);
            if (players.Count == 0)
            {
                viewportRects.ForEach(r =>
                {
                    PlayerElement player = Instantiate(playerPrefab);
                    player.SetViewPortRect(r);
                    player.action += OnAction;
                    players.Add(player);
                });
            }
            players.ForEach(p => 
            {
                p.gameObject.SetActive(true);
                p.transform.SetPositionAndRotation(generator.GetRandomPosition(), Quaternion.identity);
            });
        }

        public void Setup(GrailElement grail)
        {
            this.grail = grail;
        }

        public override void Stop()
        {
            Destroy(grail.gameObject);
        }

        private void OnAction(PlayerElement player)
        {
            if(Vector3.Distance(player.transform.position, grail.transform.position) <= 1f)
            {
                Change<EndState>()
                    .Setup(player, players);
            }
        }
    }
}