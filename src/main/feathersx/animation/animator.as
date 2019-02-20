package feathersx.animation {
import feathersx.animation.animators.Animator;
import feathersx.animation.core.Animators;

public function animator(control: Object): Animator {
    return Animators.getAnimatorForControl(control);
}
}