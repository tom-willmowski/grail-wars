using UnityEngine;

namespace Bice.GrailWars.View
{
    public class PlayerElement : MonoBehaviour
    {
        [SerializeField]
        private Camera fppCamera;

        public void SetViewPortRect(Rect rect)
        {
            fppCamera.rect = rect;
        }
    }
}
