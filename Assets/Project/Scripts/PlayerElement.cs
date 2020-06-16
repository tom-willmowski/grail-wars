using UnityEngine;
using UnityEngine.InputSystem;
using static UnityEngine.InputSystem.InputAction;

namespace Bice.GrailWars.View
{
    public class PlayerElement : MonoBehaviour
    {
        public const string SPEED_ID = "Speed";

        [SerializeField]
        private Animator animator;
        [SerializeField]
        private InputActionReference moveAction;
        [SerializeField]
        private CharacterController controller;
        [SerializeField]
        private float speed;

        private Vector2 moveInput;

        private void Awake()
        {
            moveAction.action.canceled += OnMoveCanceled;
        }

        private void OnMoveCanceled(CallbackContext context)
        {
            moveInput = Vector2.zero;
        }

        public void Move(CallbackContext context)
        {
            Vector2 value = context.ReadValue<Vector2>();
            this.moveInput = value;
        }

        public void Move()
        {
            controller.Move(new Vector3(moveInput.x, 0, -moveInput.y));
        }

        private void Update()
        {
            if (moveInput != Vector2.zero)
            {
                Move();
            }
        }
    }
}
