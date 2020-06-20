using UnityEngine;
using UnityEngine.SceneManagement;

namespace Bice.GrailWars.Systems
{
    [CreateAssetMenu(menuName = "Bice/System/DebugSystem")]
    public class DebugSystem : AbstractSystem
    {
        private GameplayInputActions debugActions;

        public override void Init()
        {
            debugActions = new GameplayInputActions();
            debugActions.Gameplay.Restart.started += Restart;
        }

        public override void Resume()
        {
            debugActions.Enable();
        }

        private void Restart(UnityEngine.InputSystem.InputAction.CallbackContext ctx)
        {
            SceneManager.LoadScene(0);
        }

        public override void Stop()
        {
            debugActions.Disable();
            debugActions.Dispose();
        }
    }
}