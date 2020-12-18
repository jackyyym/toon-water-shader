using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    [SerializeField] private float turnSpeed = 5f;
    [SerializeField] private float moveSpeed = 1f;
    private float xRot;

    void Start() {
        xRot = -transform.eulerAngles.x;
    }

    void FixedUpdate() {

        // turning controls
        if (Input.GetMouseButton(1)) {
            xRot += Input.GetAxis("Mouse Y") * turnSpeed;
            xRot = Mathf.Clamp(xRot, -90f, 90f);
            float y = Input.GetAxis("Mouse X") * turnSpeed;
            transform.eulerAngles = new Vector3(-xRot, transform.eulerAngles.y + y, 0);
        }

        // moving controls
        float v = Input.GetAxis("Vertical") * moveSpeed;
        float h = Input.GetAxis("Horizontal") * moveSpeed;
        transform.Translate(h, 0, v);

    }
}
