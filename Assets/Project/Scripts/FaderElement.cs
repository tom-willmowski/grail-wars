using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using System;

namespace Bice.GrailWars.View
{
    public class FaderElement : MonoBehaviour
    {
        [SerializeField]
        private Image blende;
        [SerializeField]
        private float duration;

        [ContextMenu("In")]
        public void In(Action complete = null)
        {
            blende.DOFade(255, duration).OnComplete(() => complete?.Invoke());
        }

        [ContextMenu("Out")]
        public void Out(Action complete = null)
        {
            blende.DOFade(0, duration).OnComplete(() => complete?.Invoke());
        }
    }
}
