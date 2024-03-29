using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(CharacterController))]
public class FirstPersonController : MonoBehaviour
{
    [Range(1f, 5f)]
    public float MovementSpeed = 1f;

    [Range(1, 200f)]
    public float LookSensitivity = 10f;

    [SerializeField]
    private Animator animator;

    [SerializeField]
    private CharacterController controller;
    [SerializeField]
    private PlayerInput input;

    private Vector2 movementInput;
    private Vector2 lookPosition;

    private Transform cameraTransform;

    private float cameraTilt = 0f;
    private float runMultiplier = 1f;

    private void Awake()
    {
        input.actions["Move"].performed += ctx => movementInput = ctx.ReadValue<Vector2>();
        input.actions["Move"].canceled += ctx => movementInput = Vector2.zero;

        input.actions["Look"].performed += ctx => lookPosition = ctx.ReadValue<Vector2>();
        input.actions["Look"].canceled += ctx => lookPosition = Vector2.zero;

        input.actions["Run"].started += ctx => runMultiplier = 2f;
        input.actions["Run"].canceled += ctx => runMultiplier = 1f;
    }

    private void Start()
    {
        this.cameraTransform = this.GetComponentInChildren<Camera>().transform;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Confined;
    }

    private void Update()
    {
        Vector3 movementVector = this.transform.forward * movementInput.y;
        if (movementVector.sqrMagnitude > 1)
        { // this check prevents partial joystick input from becoming 100% speed
            movementVector.Normalize();  // this prevents diagonal movement form being too fast
        }
        Vector3 motion = movementVector * (this.MovementSpeed * runMultiplier);
        controller.SimpleMove(motion);

        this.transform.rotation = Quaternion.AngleAxis(lookPosition.x * Time.deltaTime * this.LookSensitivity, Vector3.up) * this.transform.rotation;
        this.cameraTilt = Mathf.Clamp(this.cameraTilt - lookPosition.y * this.LookSensitivity * Time.deltaTime, -90f, 90f);
        this.cameraTransform.localRotation = Quaternion.AngleAxis(this.cameraTilt, Vector3.right);

        animator.SetFloat("Speed", movementVector.sqrMagnitude * runMultiplier);
    }
}