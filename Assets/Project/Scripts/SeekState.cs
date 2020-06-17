using Bice.Code.States;
using Bice.GrailWars.View;
using System.Collections.Generic;
using UnityEngine;

namespace Bice.GrailWars.States
{
    [CreateAssetMenu(menuName = "Bice/State/Seek")]
    public class SeekState : GameState
    {
        [SerializeField]
        private PlayerElement playerPrefab;
        [SerializeField]
        private Vector3 defaultPosition;
        [SerializeField]
        private List<Rect> viewportRects;

        private List<PlayerElement> players = new List<PlayerElement>();

        public override void Start()
        {
            viewportRects.ForEach(r => 
            {
                PlayerElement player = Instantiate(playerPrefab, defaultPosition, Quaternion.identity);
                player.SetViewPortRect(r);
                players.Add(player);
            });
        }
    }
}