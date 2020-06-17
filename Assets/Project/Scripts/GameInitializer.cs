using UnityEngine;

namespace Bice.GrailWars
{
    public class GameInitializer : MonoBehaviour
    {
        [SerializeField]
        private GameContext context;

        private void Awake()
        {
            context.Create(context);
            context.Init();
        }

        private void Start()
        {
            context.Resume();
        }

        [ContextMenu("Resume")]
        private void Resume()
        {
            context.Resume();
        }

        [ContextMenu("Pause")]
        private void Pause()
        {
            context.Pause();
        }

        [ContextMenu("Stop")]
        private void Stop()
        {
            context.Stop();
        }

        [ContextMenu("Init")]
        private void Init()
        {
            context.Init();
        }
    }
}
