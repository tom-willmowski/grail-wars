using UnityEngine;

namespace Bice.GrailWars.Code.Systems
{
    [CreateAssetMenu(menuName = "Bice/System/ColorPallete")]
    public class ColorPaletteSystem : AbstractSystem
    {
        [SerializeField]
        private Color colorFar;
        [SerializeField]
        private Color colorNear;
        [SerializeField]
        private float distance;

        public override void Init()
        {
            UpdateFog(colorNear, colorFar, distance);
        }

        public void UpdateFog(float distance)
        {
            UpdateFog(colorNear, colorFar, distance);
        }

        public void UpdateFog(Color ColorNear, Color ColorFar, float Distance)
        {
            Shader.SetGlobalColor("_FogColorNear", ColorNear);
            Shader.SetGlobalColor("_FogColorFar", ColorFar);
            Shader.SetGlobalFloat("_FogDistance", Distance);
        }

        [ContextMenu("UpdateFog")]
        public void UpdateFog()
        {
            UpdateFog(colorNear, colorFar, distance);
        }

        public override void Stop()
        {
            UpdateFog(colorNear, colorFar, distance);
        }
    }
}
